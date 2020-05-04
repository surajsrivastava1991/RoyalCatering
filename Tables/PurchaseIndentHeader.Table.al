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
            Caption = 'Name';
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
            OptionMembers = Open,Approved,"Pending Approval","Approved-Ordered","Approved-Partially Ordered","Approved-Received","Approved-Partially Received","Approved-Cancel";
        }
        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
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
            "Created By" := UserId();
            "Creation Date" := Today();
        end;
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
}