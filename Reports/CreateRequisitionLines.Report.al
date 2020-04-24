report 50053 "Create Requisition Lines"
{
    Caption = 'Create Requisition Lines';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PurchaseIndentHeader; "Purchase Indent Header")
        {
            dataitem("Purchase Indent Line"; "Purchase Indent Line")
            {
                DataItemTableView = sorting("Document No.") where(flag = const(false));
                DataItemLinkReference = PurchaseIndentHeader;
                DataItemLink = "Document No." = field("No.");
                trigger OnAfterGetRecord()
                begin
                    LineNoG := 0;
                    PurchaseSetup.Get();
                    RequisitionLineG.LockTable();
                    RequisitionLineG.Reset();
                    RequisitionLineG.SetRange("Worksheet Template Name", PurchaseSetup."Req. Wksh. Template");
                    RequisitionLineG.SetRange("Journal Batch Name", PurchaseSetup."Requisition Wksh. Name");
                    if RequisitionLineG.FindLast() then
                        LineNoG := RequisitionLineG."Line No.";
                    LineNoG += 10000;
                    RequisitionLineG.Init();
                    RequisitionLineG."Worksheet Template Name" := PurchaseSetup."Req. Wksh. Template";
                    RequisitionLineG."Journal Batch Name" := PurchaseSetup."Requisition Wksh. Name";
                    RequisitionLineG."Line No." := LineNoG;
                    RequisitionLineG."Replenishment System" := RequisitionHdrG."Replenishment Type";
                    LineNoG += 10000;
                    RequisitionLineG.Validate(Type, Type);
                    RequisitionLineG.Validate("No.", "No.");
                    RequisitionLineG.Validate("Location Code", "Receiving Location");
                    RequisitionLineG.Validate(Quantity, Quantity);
                    //RequisitionLineG.Validate("Vendor No.", "Buy-from Vendor No.");
                    RequisitionHdrG.GET("Document No.");
                    RequisitionLineG.Validate("Replenishment System", RequisitionHdrG."Replenishment Type");
                    RequisitionLineG."Req. Document No." := "No.";
                    RequisitionLineG."Req. Line No." := "Line No.";
                    RequisitionLineG.Insert(true);
                    Flag := true;
                    Modify();
                end;
            }

        }

    }
    var
        RequisitionLineG: Record "Requisition Line";
        RequisitionHdrG: Record "Purchase Indent Header";
        PurchaseSetup: Record "Purchases & Payables Setup";
        LineNoG: Integer;
}