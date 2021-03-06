table 50036 "Purchase Indent Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
            trigger OnValidate()
            begin
                TestStatusOpen();
                PurchIndentHdrG.Reset();
                PurchIndentHdrG.get("Document No.");
                PurchIndentHdrG.TestField("Requested Date");
                PurchIndentHdrG.TestField("Receiving Location");
                if PurchIndentHdrG."Replenishment Type" = PurchIndentHdrG."Replenishment Type"::Transfer then
                    PurchIndentHdrG.TestField("From Location");
                "Item Category Code" := PurchIndentHdrG."Item Category Code";
                "Receiving Location" := PurchIndentHdrG."Receiving Location";
                "Requested Date" := PurchIndentHdrG."Requested Date";
                "Replenishment Type" := PurchIndentHdrG."Replenishment Type";
                "From Location" := PurchIndentHdrG."From Location";
            end;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item), "Item Category Code" = CONST('')) Item where(type = const(Inventory))
            else
            if (type = const(Item), "Item Category Code" = FILTER(<> '')) Item WHERE("Item Category Code" = field("Item Category Code"));
            trigger OnValidate()
            begin
                TestStatusOpen();
                if Type = Type::Item then
                    if ItemG.Get("No.") then begin
                        Description := ItemG.Description;
                        "Description 2" := ItemG."Description 2";
                        if "Item Category Code" <> '' then
                            "Item Category Code" := ItemG."Item Category Code";
                        Validate("Requested Date");
                    end;
                if "Replenishment Type" = "Replenishment Type"::Purchase then begin
                    LocationwisePurchaser.get("Receiving Location", "Item Category Code", 0);
                    "Purchaser Code" := LocationwisePurchaser."Purchaser Code";
                    "Unit of Measure Code" := ItemG."Purch. Unit of Measure";
                end else begin
                    LocationwisePurchaser.get("From Location", "Item Category Code", 1);
                    "Purchaser Code" := LocationwisePurchaser."Purchaser Code";
                    "Unit of Measure Code" := ItemG."Base Unit of Measure";
                end;
            end;
        }
        field(6; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(7; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(8; "Receiving Location"; Code[10])
        {
            Editable = false;
            Caption = 'Receiving Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(9; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Variant";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(11; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(13; "Creation Date"; Date)
        {
            Editable = false;
            Caption = 'Indent Date';
            DataClassification = CustomerContent;
        }
        field(14; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(15; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(17; "Flag"; Boolean)
        {
            Editable = false;
            Caption = 'Flag';
            DataClassification = ToBeClassified;
        }
        field(18; "Ref. Document Type"; Option)
        {
            OptionMembers = " ","Purchase Quote","Purchase Order","Transfer Order",Cancel;
            Caption = 'Doc Type';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Ref. Document No."; Code[50])
        {
            Caption = 'Ref. Document No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Ref. Document Line No."; Integer)
        {
            Caption = 'Ref. Document Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Requested Date"; Date)
        {
            Caption = 'Requested Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
                if "Requested Date" = 0D then
                    exit;
                if PurIndHdrG."Replenishment Type" = PurIndHdrG."Replenishment Type"::Purchase then
                    Validate("Order Date",
                          LeadTimeMgt.PlannedEndingDate("No.", "Receiving Location", "Variant Code", "Requested Date", '', 1));
                if PurIndHdrG."Replenishment Type" = PurIndHdrG."Replenishment Type"::Transfer then
                    Validate("Order Date",
                          LeadTimeMgt.PlannedEndingDate("No.", "Receiving Location", "Variant Code", "Requested Date", '', 3))
            end;
        }
        field(22; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(23; "Purchaser Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(24; "From Location"; Code[10])
        {
            Editable = false;
            Caption = 'From Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(25; "Transaction Status"; Option)
        {
            Caption = 'Transaction Status';
            Editable = false;
            //OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval","Approved-Ordered","Approved-Partially Ordered","Approved-Received","Approved-Partially Received","Approved-Cancel";
        }
        field(26; "Replenishment Type"; Option)
        {
            Caption = 'Replenishment Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Purchase,Transfer;
            OptionCaption = ' ,Purchase,Transfer';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        if PurchIndentHdrG.get("Document No.") then
            PurchIndentHdrG.TestField("Approval Status", PurchIndentHdrG."Approval Status"::Open);
    end;

    var
        PurchIndentHdrG: record "Purchase Indent Header";
        ItemG: Record Item;
        PurIndHdrG: Record "Purchase Indent Header";
        LocationwisePurchaser: Record "Locationwise Purchaser";
        LeadTimeMgt: Codeunit "Lead-Time Management";

    procedure TestStatusOpen()
    var
        IndHeaderL: Record "Purchase Indent Header";
    begin
        IndHeaderL.get("Document No.");
        IndHeaderL.TestField("Approval Status", IndHeaderL."Approval Status"::Open);
    end;

}