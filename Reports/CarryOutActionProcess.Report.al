report 50054 "Carry Out Action Process"
{
    Caption = 'Carry Out Action Process';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOrders; PrintOrders)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Print Orders';
                        ToolTip = 'Specifies whether to print the purchase orders after they are created.';
                    }
                    field(ItemGrouping; ItemGrouping)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Item Grouping';
                        ToolTip = 'Consolidated order line for same items';
                        trigger OnValidate()
                        begin
                            if ItemGrouping = false then
                                DeliveryDateGrouping := false;
                        end;
                    }
                    field(DeliveryDateGrouping; DeliveryDateGrouping)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Delivery Date Grouping';
                        ToolTip = 'Consolidated order line for same irrespective to delivery date';
                        trigger OnValidate()
                        begin
                            if not ItemGrouping then
                                Error('Item Grouping must be enabled.');
                        end;
                    }
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = Planning;
                        Caption = 'From Date';
                        ToolTip = 'Order date filter';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = Planning;
                        Caption = 'To Date';
                        ToolTip = 'Order date filter';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PurchOrderHeader."Order Date" := WorkDate();
            PurchOrderHeader."Posting Date" := WorkDate();
            PurchOrderHeader."Expected Receipt Date" := WorkDate();
            if ReqWkshTmpl.Recurring then
                EndOrderDate := WorkDate()
            else
                EndOrderDate := 0D;
        end;
    }

    labels
    {
    }
    trigger OnInitReport()
    begin
        PurchSetupG.get();
        ItemGrouping := PurchSetupG."Item Grouping";
        DeliveryDateGrouping := PurchSetupG."Group on Delivery Date";
        if not ItemGrouping then
            DeliveryDateGrouping := false;
    end;

    trigger OnPreReport()
    begin
        OnBeforePreReport(PrintOrders);
        //Aplica.1.0 -->>
        if (FromDate <> 0D) and (ToDate <> 0D) then
            ReqLine.SetRange("Order Date", FromDate, ToDate);
        //Aplica.1.0 <<--
        UseOneJnl(ReqLine);
    end;

    var

        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";
        ReqLine: Record "Requisition Line";
        PurchOrderHeader: Record "Purchase Header";
        PurchSetupG: Record "Purchases & Payables Setup";
        ReqWkshMakeOrders: Codeunit "Req. Wksh.-Make Order-Mofified";
        EndOrderDate: Date;
        PrintOrders: Boolean;
        TempJnlBatchName: Code[10];
        HideDialog: Boolean;
        SuppressCommit: Boolean;
        FromDate: Date;
        ToDate: Date;
        ItemGrouping: Boolean;
        DeliveryDateGrouping: Boolean;
        DelivryDateVisible: Boolean;
        Text000: Label 'cannot be filtered when you create orders';
        Text001: Label 'There is nothing to create.';
        Text003: Label 'You are now in worksheet %1.';


    procedure SetReqWkshLine(var NewReqLine: Record "Requisition Line")
    begin
        ReqLine.Copy(NewReqLine);
        ReqWkshTmpl.Get(NewReqLine."Worksheet Template Name");

        OnAfterSetReqWkshLine(NewReqLine);
    end;

    procedure GetReqWkshLine(var NewReqLine: Record "Requisition Line")
    begin
        NewReqLine.Copy(ReqLine);
    end;

    procedure SetReqWkshName(var NewReqWkshName: Record "Requisition Wksh. Name")
    begin
        ReqWkshName.Copy(NewReqWkshName);
        ReqWkshTmpl.Get(NewReqWkshName."Worksheet Template Name");
    end;

    local procedure UseOneJnl(var ReqLine: Record "Requisition Line")
    begin
        with ReqLine do begin
            ReqWkshTmpl.Get("Worksheet Template Name");
            if ReqWkshTmpl.Recurring and (GetFilter("Order Date") <> '') then
                FieldError("Order Date", Text000);
            TempJnlBatchName := "Journal Batch Name";
            ReqWkshMakeOrders.Set(PurchOrderHeader, EndOrderDate, PrintOrders);
            ReqWkshMakeOrders.SetItemGrouping(ItemGrouping, DeliveryDateGrouping);
            ReqWkshMakeOrders.SetSuppressCommit(SuppressCommit);
            ReqWkshMakeOrders.CarryOutBatchAction(ReqLine);

            if "Line No." = 0 then
                Message(Text001)
            else
                if not HideDialog then
                    if TempJnlBatchName <> "Journal Batch Name" then
                        Message(
                          Text003,
                          "Journal Batch Name");

            if not Find('=><') or (TempJnlBatchName <> "Journal Batch Name") then begin
                Reset();
                FilterGroup := 2;
                SetRange("Worksheet Template Name", "Worksheet Template Name");
                SetRange("Journal Batch Name", "Journal Batch Name");
                FilterGroup := 0;
                "Line No." := 1;
            end;
        end;
    end;

    procedure InitializeRequest(ExpirationDate: Date; OrderDate: Date; PostingDate: Date; ExpectedReceiptDate: Date; YourRef: Text[35])
    begin
        EndOrderDate := ExpirationDate;
        PurchOrderHeader."Order Date" := OrderDate;
        PurchOrderHeader."Posting Date" := PostingDate;
        PurchOrderHeader."Expected Receipt Date" := ExpectedReceiptDate;
        PurchOrderHeader."Your Reference" := YourRef;
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    procedure SetSupressCommit(NewSupressCommit: Boolean)
    begin
        SuppressCommit := NewSupressCommit;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetReqWkshLine(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforePreReport(var PrintOrders: Boolean)
    begin
    end;
}

