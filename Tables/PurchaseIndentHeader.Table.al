table 50035 "Purchase Indent Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
                if "No." <> xRec."No." then begin
                    PurchseSetupG.Get();
                    if "Replenishment Type" = "Replenishment Type"::Purchase then
                        NoSeriesMgtG.TestManual(PurchseSetupG."Requisition Nos.(Purchase)")
                    else
                        NoSeriesMgtG.TestManual(PurchseSetupG."Requisition Nos.(Transfer)");

                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Creation Date"; Date)
        {
            Editable = false;
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(3; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
            trigger OnValidate()
            var
                PurchIndentLineL: Record "Purchase Indent Line";
            begin
                "Transaction Status" := "Approval Status";
                PurchIndentLineL.Reset();
                PurchIndentLineL.SetRange("Document No.", "No.");
                PurchIndentLineL.ModifyAll("Transaction Status", "Approval Status");
            end;
        }
        field(4; "Replenishment Type"; Option)
        {
            Caption = 'Replenishment Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Purchase,Transfer;
            OptionCaption = ' ,Purchase,Transfer';
            Editable = false;
        }
        field(5; "Name"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(6; "Requester"; Code[50])
        {
            Caption = 'Requester';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(7; "Requested Date"; date)
        {
            Caption = 'Requested Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(8; "Receiving Location"; Code[10])
        {
            Caption = 'Receiving Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(9; "Created By"; Code[50])
        {
            Editable = false;
            Caption = 'Created By';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(10; "Details"; Text[250])
        {
            Caption = 'Details';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(11; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(12; "From Location"; Code[10])
        {
            Caption = 'From Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(13; "Transaction Status"; Option)
        {
            Caption = 'Transaction Status';
            Editable = false;
            //OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval","Approved-Ordered","Approved-Partially Ordered","Approved-Received","Approved-Partially Received","Approved-Cancel","Aproved-Quote Created","Approved-Partially Quote Created";
        }
        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(14; "Requisition Type"; Option)
        {
            Caption = 'Requisition Type';
            OptionMembers = Item,"Service Item","Fixed Asset";
            OptionCaption = 'Item,Service Item,Fixed Asset';
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            PurchseSetupG.Get();
            if "Replenishment Type" = "Replenishment Type"::Purchase then begin
                PurchseSetupG.TestField("Requisition Nos.(Purchase)");
                NoSeriesMgtG.InitSeries(PurchseSetupG."Requisition Nos.(Purchase)", xRec."No. Series", Today, "No.", "No. Series");
            end else begin
                PurchseSetupG.TestField("Requisition Nos.(Transfer)");
                NoSeriesMgtG.InitSeries(PurchseSetupG."Requisition Nos.(Transfer)", xRec."No. Series", Today, "No.", "No. Series");
            end;
        end;
        "Created By" := UserId();
        "Creation Date" := Today();
    end;

    trigger OnModify()
    begin
        if Format(Rec) = Format(xRec) then
            exit;
        PurIndentLine.Reset();
        PurIndentLine.SetRange(PurIndentLine."Document No.", "No.");
        //if PurIndentLine.Find('-') then
        //  Error('You dont have modify permission for this document');
    end;

    trigger OnDelete()
    begin
        TestField("Approval Status", "Approval Status"::Open);
    end;

    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        PurchseSetupG: Record "Purchases & Payables Setup";
        RequisitionLineG: Record "Requisition Line";
        RequisitionHdrG: Record "Purchase Indent Header";
        PurIndentLine: Record "Purchase Indent Line";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        LineNoG: Integer;

    procedure AssistEdit(OldRequisitionHeaderP: Record "Purchase Indent Header"): Boolean
    var
        RequisitionHeaderL: Record "Purchase Indent Header";
        PurchseSetupL: Record "Purchases & Payables Setup";
        Text051: Label 'The sales %1 %2 already exists.';
    begin
        with OldRequisitionHeaderP do begin
            Copy(Rec);
            PurchseSetupL.Get();
            if "Replenishment Type" = "Replenishment Type"::Purchase then begin
                PurchseSetupL.TestField("Requisition Nos.(Purchase)");

                if NoSeriesMgtG.SelectSeries(PurchseSetupL."Requisition Nos.(Purchase)", OldRequisitionHeaderP."No. Series", "No. Series") then begin
                    NoSeriesMgtG.SetSeries("No.");
                    if RequisitionHeaderL.Get("No.") then
                        Error(Text051, 'Requisirion No.(Purchase)', "No.");
                    Rec := OldRequisitionHeaderP;
                    exit(true);
                end;
            end else begin
                PurchseSetupL.TestField("Requisition Nos.(Transfer)");

                if NoSeriesMgtG.SelectSeries(PurchseSetupL."Requisition Nos.(Transfer)", OldRequisitionHeaderP."No. Series", "No. Series") then begin
                    NoSeriesMgtG.SetSeries("No.");
                    if RequisitionHeaderL.Get("No.") then
                        Error(Text051, 'Requisition Nos.(Transfer)', "No.");
                    Rec := OldRequisitionHeaderP;
                    exit(true);
                end;
            end;

        end;
    end;

    procedure CreateRequisitionLines()
    var
        RequLinesL: Record "Purchase Indent Line";
    begin
        RequLinesL.reset();
        RequLinesL.SetRange("Document No.", "No.");
        if RequLinesL.FindSet() then
            repeat
                with RequLinesL do begin
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
                    //LineNoG += 10000;
                    RequisitionLineG.Validate(Type, Type);
                    RequisitionLineG.Validate("No.", "No.");
                    RequisitionLineG.Validate("Location Code", "Receiving Location");
                    RequisitionLineG.Validate(Quantity, Quantity);
                    if "From Location" <> '' then
                        RequisitionLineG.Validate("Transfer-from Code", "From Location");
                    /*
                    if "Direct Unit Cost" <> 0 then begin
                        RequisitionLineG."Direct Unit Cost" := "Direct Unit Cost";
                        RequisitionLineG."Vendor Trade Agreement" := "Trade agreement exist";
                    end;
                    */
                    //RequisitionLineG.Validate("Vendor No.", "Buy-from Vendor No.");
                    RequisitionLineG.SetCurrFieldNo(12);
                    RequisitionLineG.Validate("Due Date", "Requested Date");
                    RequisitionLineG.SetCurrFieldNo(0);
                    if "Replenishment Type" = "Replenishment Type"::Purchase then
                        RequisitionLineG."Replenishment System" := RequisitionLineG."Replenishment System"::Purchase
                    else
                        if "Replenishment Type" = "Replenishment Type"::Transfer then
                            RequisitionLineG."Replenishment System" := RequisitionLineG."Replenishment System"::Transfer;
                    RequisitionLineG.Validate("Replenishment System");
                    if "Replenishment Type" = "Replenishment Type"::Transfer then begin
                        RequisitionLineG.SetCurrFieldNo(12);
                        RequisitionLineG.Validate("Due Date", "Requested Date");
                        RequisitionLineG.SetCurrFieldNo(0);
                    end;
                    if "From Location" <> '' then
                        RequisitionLineG.Validate("Transfer-from Code", "From Location");
                    RequisitionHdrG.GET("Document No.");
                    RequisitionLineG."Req. Document No." := "Document No.";
                    RequisitionLineG."Req. Line No." := "Line No.";
                    RequisitionLineG."From Request" := true;
                    RequisitionLineG."Purchaser Code" := "Purchaser Code";
                    RequisitionLineG.Insert(true);
                    Flag := true;
                    Modify();
                end
            until RequLinesL.next() = 0;
    end;

    procedure TestStatusOpen()
    begin
        TestField("Approval Status", "Approval Status"::Open);
    end;

    //Service Requisition
    procedure InsertPurchOrderLine(var IndentLine2: Record "Purchase Indent Line"; var PurchOrderHeader: Record "Purchase Header"; var PurchOrderLine: Record "Purchase Line")
    var
        PurchOrderLine2: Record "Purchase Line";
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        DimensionSetIDArr: array[10] of Integer;
    begin
        with IndentLine2 do begin
            if ("No." = '') or ("Vendor No." = '') or (Quantity = 0) then
                exit;

            if CheckInsertFinalizePurchaseQuoteHeader(IndentLine2, PurchOrderHeader, true) then begin
                InsertHeader(IndentLine2);
                //LineCount := 0;
                NextLineNo := 0;
                //PrevPurchCode := "Purchasing Code";
                //PrevShipToCode := "Ship-to Code";
                //PrevLocationCode := "Location Code";
            end;
            //TestField("Currency Code", PurchOrderHeader."Currency Code");

            InitPurchOrderLine(PurchOrderLine, PurchOrderHeader, IndentLine2);

            //AddOnIntegrMgt.TransferFromReqLineToPurchLine(PurchOrderLine, IndentLine2);

            //PurchOrderLine."Drop Shipment" := "Sales Order Line No." <> 0;

            PurchOrderLine.Insert();

            IndentLine2."Ref. Document Type" := IndentLine2."Ref. Document Type"::"Purchase Order";
            IndentLine2."Ref. Document No." := PurchOrderLine."Document No.";
            IndentLine2."Ref. Document Line No." := PurchOrderLine."Line No.";
            IndentLine2.Modify();

            UpdateRequisitionStatus(IndentLine2);

            PurchOrderLine2.SetRange("Document Type", PurchOrderHeader."Document Type");
            PurchOrderLine2.SetRange("Document No.", PurchOrderHeader."No.");
            if PurchOrderLine2.FindLast() then
                NextLineNo := PurchOrderLine2."Line No.";
        end;
    end;

    local procedure InsertHeader(var IndentLine2: Record "Purchase Indent Line")
    var
        SalesHeader: Record "Sales Header";
        Vendor: Record Vendor;
        SpecialOrder: Boolean;
    begin

        with IndentLine2 do begin

            PurchSetup.Get();
            PurchSetup.TestField("Order Nos.");
            Clear(PurchOrderHeader);
            PurchOrderHeader.Init();
            PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::Order;
            PurchOrderHeader."No." := '';
            PurchOrderHeader."Posting Date" := WorkDate();
            PurchOrderHeader.Insert(true);
            PurchOrderHeader."Your Reference" := ReferenceReq;
            PurchOrderHeader."Order Date" := WorkDate();
            PurchOrderHeader."Expected Receipt Date" := WorkDate();
            PurchOrderHeader.Validate("Buy-from Vendor No.", "Vendor No.");

            PurchOrderHeader.Validate("Currency Code", "Currency Code");

            PurchOrderHeader.Validate("Location Code", "Receiving Location");
            if Vendor.Get(PurchOrderHeader."Buy-from Vendor No.") then
                PurchOrderHeader.Validate("Shipment Method Code", Vendor."Shipment Method Code");
        end;
        PurchOrderHeader."Ref. Requisition ID" := IndentLine2.RecordId;
        PurchOrderHeader."Assigned User ID" := UserId;
        PurchOrderHeader.Modify();
        PurchOrderHeader.Mark(true);
    end;

    procedure InitPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; IndentLineP: Record "Purchase Indent Line")
    begin
        with IndentLineP do begin
            PurchOrderLine.Init();
            PurchOrderLine.BlockDynamicTracking(true);
            PurchOrderLine."Document Type" := PurchOrderLine."Document Type"::Order;
            PurchOrderLine."Buy-from Vendor No." := "Vendor No.";
            PurchOrderLine."Document No." := PurchOrderHeader."No.";
            NextLineNo := NextLineNo + 10000;
            PurchOrderLine."Line No." := NextLineNo;
            if Type = Type::"Item(Service)" then
                PurchOrderLine.Validate(Type, PurchOrderLine.Type::Item)
            else
                PurchOrderLine.Validate(Type, PurchOrderLine.Type::"Fixed Asset");
            PurchOrderLine.Validate("No.", "No.");
            PurchOrderLine."Variant Code" := "Variant Code";
            PurchOrderLine.Validate("Unit of Measure Code", "Unit of Measure Code");
            PurchOrderLine.Validate("Qty. to Accept", Quantity);
            //PurchOrderLine.Validate("Location Code", "Receiving Location");
            if PurchOrderHeader."Prices Including VAT" then
                PurchOrderLine.Validate("Direct Unit Cost", "Direct Unit Cost" * (1 + PurchOrderLine."VAT %" / 100))
            else
                PurchOrderLine.Validate("Direct Unit Cost", "Direct Unit Cost");
            PurchOrderLine.Description := Description;
            PurchOrderLine."Description 2" := "Description 2";
            PurchOrderLine."Item Category Code" := "Item Category Code";
            if "Requested Date" <> 0D then begin
                PurchOrderLine.Validate("Expected Receipt Date", "Requested Date");
                PurchOrderLine."Requested Receipt Date" := PurchOrderLine."Planned Receipt Date";
            end;
        end;

    end;
    //Service Quotes Order
    procedure FindAllVendorsForQuotes(var IndentLineP: Record "Purchase Indent Line")
    var
        IndentLineL: Record "Purchase Indent Line";
        QuoteVendors: Record "Vendors For Quotations";
    begin
        IndentLineL.Copy(IndentLineP);
        VendorG.Reset();
        IndentLineL.SetRange("No.", IndentLineL."No.");
        if IndentLineL.FindSet() then
            repeat
                QuoteVendors.Reset();
                QuoteVendors.SetRange("Document No.", IndentLineL."Document No.");
                QuoteVendors.SetRange("Line No.", IndentLineL."Line No.");
                if QuoteVendors.FindSet() then
                    repeat
                        if VendorG.Get(QuoteVendors."Vendor No.") then
                            VendorG.Mark(true);
                    until QuoteVendors.Next() = 0;
            until IndentLineL.Next() = 0;
    end;

    procedure InsertPurchQuoteLine(var IndentLine2: Record "Purchase Indent Line"; var PurchOrderHeader: Record "Purchase Header"; var PurchOrderLine: Record "Purchase Line")
    var
        PurchOrderLine2: Record "Purchase Line";
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        DimensionSetIDArr: array[10] of Integer;
        QuoteVendorsL: Record "Vendors For Quotations";
    begin
        with IndentLine2 do begin
            if IndentLine2."Order/Quote" = IndentLine2."Order/Quote"::"Purchase Order" then
                if ("No." = '') or ("Vendor No." = '') or (Quantity = 0) then
                    exit;
            if IndentLine2."Order/Quote" = IndentLine2."Order/Quote"::"Purchase Quote" then
                if ("No." = '') or (Quantity = 0) then
                    exit;

            FindAllVendorsForQuotes(IndentLine2);
            VendorG.MarkedOnly(true);
            if VendorG.FindSet() then
                repeat
                    if CheckInsertFinalizePurchaseQuoteHeader2(IndentLine2, PurchOrderHeader, true, VendorG) then begin
                        InsertQuoteHeader(IndentLine2, VendorG);
                        NextLineNo := 0;
                    end;

                    InitPurchQuoteLine(PurchOrderLine, PurchOrderHeader, IndentLine2, VendorG);

                    PurchOrderLine.Insert();
                    IndentLine2."Ref. Document Type" := IndentLine2."Ref. Document Type"::"Purchase Quote";
                    IndentLine2."Ref. Document No." := PurchOrderLine."Document No.";
                    IndentLine2."Ref. Document Line No." := PurchOrderLine."Line No.";
                    IndentLine2.Modify();
                    //To update quote reference in Vendors for Quotation table
                    QuoteVendorsL.Reset();
                    QuoteVendorsL.SetRange("Document No.", IndentLine2."Document No.");
                    QuoteVendorsL.SetRange("Line No.", IndentLine2."Line No.");
                    QuoteVendorsL.SetRange("Vendor No.", VendorG."No.");
                    if QuoteVendorsL.FindSet(true) then
                        repeat
                            QuoteVendorsL."Quote Doc. No." := PurchOrderLine."Document No.";
                            QuoteVendorsL."Quote Line No." := PurchOrderLine."Line No.";
                            QuoteVendorsL.Modify();
                        until QuoteVendorsL.Next() = 0;

                    UpdateRequisitionStatusQuote(IndentLine2);

                    PurchOrderLine2.SetRange("Document Type", PurchOrderHeader."Document Type");
                    PurchOrderLine2.SetRange("Document No.", PurchOrderHeader."No.");
                    if PurchOrderLine2.FindLast() then
                        NextLineNo := PurchOrderLine2."Line No.";
                until VendorG.Next() = 0;
        end;
    end;

    local procedure InsertQuoteHeader(var IndentLine2: Record "Purchase Indent Line"; VendorP: Record Vendor)
    var
        SalesHeader: Record "Sales Header";
        Vendor: Record Vendor;
        SpecialOrder: Boolean;
    begin

        with IndentLine2 do begin

            PurchSetup.Get();
            PurchSetup.TestField("Order Nos.");
            Clear(PurchOrderHeader);
            PurchOrderHeader.Init();
            PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::Quote;
            PurchOrderHeader."No." := '';
            PurchOrderHeader."Posting Date" := WorkDate();
            PurchOrderHeader.Insert(true);
            PurchOrderHeader."Your Reference" := ReferenceReq;
            PurchOrderHeader."Order Date" := WorkDate();
            PurchOrderHeader."Expected Receipt Date" := WorkDate();
            PurchOrderHeader.Validate("Buy-from Vendor No.", VendorP."No.");

            PurchOrderHeader.Validate("Currency Code", "Currency Code");

            PurchOrderHeader.Validate("Location Code", "Receiving Location");
            if Vendor.Get(PurchOrderHeader."Buy-from Vendor No.") then
                PurchOrderHeader.Validate("Shipment Method Code", Vendor."Shipment Method Code");
        end;
        PurchOrderHeader."Assigned User ID" := '';
        PurchOrderHeader.Modify();
        PurchOrderHeader.Mark(true);
    end;

    procedure InitPurchQuoteLine(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; IndentLineP: Record "Purchase Indent Line"; VendorP: Record Vendor)
    begin
        with IndentLineP do begin
            PurchOrderLine.Init();
            PurchOrderLine.BlockDynamicTracking(true);
            PurchOrderLine."Document Type" := PurchOrderLine."Document Type"::Quote;
            PurchOrderLine."Buy-from Vendor No." := VendorP."No.";
            PurchOrderLine."Document No." := PurchOrderHeader."No.";
            NextLineNo := NextLineNo + 10000;
            PurchOrderLine."Line No." := NextLineNo;
            if Type = Type::"Item(Service)" then
                PurchOrderLine.Validate(Type, PurchOrderLine.Type::Item)
            else
                PurchOrderLine.Validate(Type, PurchOrderLine.Type::"Fixed Asset");
            PurchOrderLine.Validate("No.", "No.");
            PurchOrderLine."Variant Code" := "Variant Code";
            PurchOrderLine.Validate("Unit of Measure Code", "Unit of Measure Code");
            PurchOrderLine.Validate("Qty. to Accept", Quantity);
            PurchOrderLine.Validate("Direct Unit Cost", 0);
            PurchOrderLine.Description := Description;
            PurchOrderLine."Description 2" := "Description 2";
            PurchOrderLine."Item Category Code" := "Item Category Code";
            if "Requested Date" <> 0D then begin
                PurchOrderLine.Validate("Expected Receipt Date", "Requested Date");
                PurchOrderLine."Requested Receipt Date" := PurchOrderLine."Planned Receipt Date";
            end;
        end;

    end;

    procedure Carryoutaction(var IndentHdr: Record "Purchase Indent Header"; var IndentLine: Record "Purchase Indent Line")
    begin
        Set(PurchOrderHeader);
        //For Service Item
        IndentLine.SetRange(Type, IndentLine.Type::"Item(Service)");
        with IndentLine do begin
            if Find('-') then
                repeat
                    if IndentLine."Order/Quote" = IndentLine."Order/Quote"::"Purchase Order" then
                        InsertPurchOrderLine(IndentLine, PurchOrderHeader, PurchOrderLine)
                    else
                        if IndentLine."Order/Quote" = IndentLine."Order/Quote"::"Purchase Quote" then
                            InsertPurchQuoteLine(IndentLine, PurchOrderHeader, PurchOrderLine)
                until Next() = 0;
        end;
        //For Fixed Asset
        IndentLine.SetRange(Type, IndentLine.Type::"Fixed Asset");
        with IndentLine do begin
            if Find('-') then
                repeat
                    if IndentLine."Order/Quote" = IndentLine."Order/Quote"::"Purchase Order" then
                        InsertPurchOrderLine(IndentLine, PurchOrderHeader, PurchOrderLine)
                    else
                        if IndentLine."Order/Quote" = IndentLine."Order/Quote"::"Purchase Quote" then
                            InsertPurchQuoteLine(IndentLine, PurchOrderHeader, PurchOrderLine)
                until Next() = 0;
        end;
    end;

    local procedure CheckInsertFinalizePurchaseQuoteHeader(IndentLineP: Record "Purchase Indent Line"; var PurchOrderHeader: Record "Purchase Header"; UpdateAddressDetails: Boolean): Boolean
    var
        CheckInsert: Boolean;
    begin
        with IndentLineP do
            CheckInsert :=
              (PurchOrderHeader."Buy-from Vendor No." <> "Vendor No.") or
              (PurchOrderHeader."Currency Code" <> "Currency Code");

        exit(CheckInsert);
    end;

    local procedure CheckInsertFinalizePurchaseQuoteHeader2(IndentLineP: Record "Purchase Indent Line"; var PurchOrderHeader: Record "Purchase Header"; UpdateAddressDetails: Boolean; var VendorP: Record Vendor): Boolean
    var
        CheckInsert: Boolean;
    begin
        with IndentLineP do
            CheckInsert :=
              (PurchOrderHeader."Buy-from Vendor No." <> VendorP."No.") or
              (PurchOrderHeader."Currency Code" <> "Currency Code");

        exit(CheckInsert);
    end;

    procedure Set(NewPurchOrderHeader: Record "Purchase Header")
    begin
        PurchOrderHeader := NewPurchOrderHeader;
        //EndOrderDate := NewEndingOrderDate;
        //PrintPurchOrders := NewPrintPurchOrder;
        OrderDateReq := PurchOrderHeader."Order Date";
        PostingDateReq := PurchOrderHeader."Posting Date";
        ReceiveDateReq := PurchOrderHeader."Expected Receipt Date";
        ReferenceReq := PurchOrderHeader."Your Reference";
        // OnAfterSet(PurchOrderHeader, SuppressCommit, EndOrderDate, PrintPurchOrders);
    end;

    procedure UpdateRequisitionStatus(var IndentLineL: Record "Purchase Indent Line")
    var
    //IndentHeaderL: Record "Purchase Indent Header";
    begin
        IndentLineL."Transaction Status" := IndentLineL."Transaction Status"::"Approved-Ordered";
        IndentLineL.Modify();
        ReqWkshMakeOrder.UpdateHeaderStatus(IndentLineL);
    end;

    procedure UpdateRequisitionStatusQuote(var IndentLineL: Record "Purchase Indent Line")
    var
    //IndentHeaderL: Record "Purchase Indent Header";
    begin
        IndentLineL."Transaction Status" := IndentLineL."Transaction Status"::"Aproved-Quote Created";
        IndentLineL.Modify();
        ReqWkshMakeOrder.UpdateHeaderStatus(IndentLineL);
    end;
    /*
        local procedure OnConditionalCardPageIDNotFound(RecRef: RecordRef; var CardPageID: Integer)
        var
            PurIndentHdrL: Record "Purchase Indent Header";
        begin
            case RecRef.Number of
                DATABASE::"Purchase Indent Header":
                    begin
                        if RecRef.Number = Database::"Purchase Indent Header" then begin
                            RecRef.SetTable(PurIndentHdrL);
                            if PurIndentHdrL."Replenishment Type" = PurIndentHdrL."Replenishment Type"::Transfer then
                                CardPageID := Page::"Transfer Indent"
                            else
                                if PurIndentHdrL."Replenishment Type" = PurIndentHdrL."Replenishment Type"::Purchase then
                                    if PurIndentHdrL."Service Requisition" = true then
                                        CardPageID := Page::"Service Indent Card"
                                    else
                                        CardPageID := Page::"Purchase Indent Card";
                        end;
                    end;
            //exit(PAGE::"General Journal Templates");        
            end;
        end;
    */
    var
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        VendorG: Record Vendor;
        ReqWkshMakeOrder: Codeunit "Req. Wksh.-Make Order-Mofified";
        PageMangmntG: Codeunit "Page Management";
        OrderDateReq: Date;
        PostingDateReq: Date;
        ReceiveDateReq: Date;
        EndOrderDate: Date;
        PlanningResiliency: Boolean;
        PrintPurchOrders: Boolean;
        ReferenceReq: Text[35];
        NextLineNo: Integer;
}