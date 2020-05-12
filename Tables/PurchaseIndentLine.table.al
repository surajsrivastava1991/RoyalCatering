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
        field(3; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("No.");
            end;

            trigger OnLookup()
            var
                Vend: Record Vendor;
            begin
                if LookupVendor(Vend, true) then
                    Validate("Vendor No.", Vend."No.");
            end;
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,,Fixed Asset,Item(Service)';
            OptionMembers = " ","G/L Account",Item,,,"Fixed Asset","Item(Service)";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item), "Item Category Code" = CONST('')) Item where(type = const(Inventory))
            else
            if (type = const(Item), "Item Category Code" = FILTER(<> '')) Item WHERE("Item Category Code" = field("Item Category Code"), Type = const(Inventory))
            else
            IF (Type = CONST("Item(Service)"), "Item Category Code" = CONST('')) Item where(type = const(Service))
            else
            if (type = const("Item(Service)"), "Item Category Code" = FILTER(<> '')) Item WHERE("Item Category Code" = field("Item Category Code"), Type = const(Service))
            else
            if (type = const("Fixed Asset")) "Fixed Asset";
            trigger OnValidate()
            begin
                TestStatusOpen();
                PurchIndentHdrG.Get("Document No.");
                PurchIndentHdrG.TestField("Requested Date");
                PurchIndentHdrG.TestField("Receiving Location");
                if PurchIndentHdrG."Replenishment Type" = PurchIndentHdrG."Replenishment Type"::Transfer then
                    PurchIndentHdrG.TestField("From Location");
                if Type IN [Type::Item, Type::"Item(Service)"] then
                    if ItemG.Get("No.") then begin
                        Description := ItemG.Description;
                        "Description 2" := ItemG."Description 2";
                        "Purchase quote mandatory" := ItemG."Quote Mandatory";
                        if "Item Category Code" <> '' then
                            "Item Category Code" := ItemG."Item Category Code";
                        Validate("Requested Date");
                        CheckOrderOrQuote();
                    end;
                if Type = Type::"Fixed Asset" then
                    CopyFromFixedAsset();
                LocationwisePurchaser.Reset();
                LocationwisePurchaser.SetRange(Location, "Receiving Location");
                LocationwisePurchaser.SetFilter("Item Category Code", '%1|%2', "Item Category Code", '');
                if "Replenishment Type" = "Replenishment Type"::Purchase then begin
                    LocationwisePurchaser.SetRange("Requisition Type", 0);
                    if LocationwisePurchaser.Find('=><') then begin
                        "Purchaser Code" := LocationwisePurchaser."Purchaser Code";
                        "Unit of Measure Code" := ItemG."Purch. Unit of Measure";
                    end;

                end else begin
                    LocationwisePurchaser.SetRange("Requisition Type", 1);
                    if LocationwisePurchaser.Find('=><') then begin
                        "Purchaser Code" := LocationwisePurchaser."Purchaser Code";
                        "Unit of Measure Code" := ItemG."Base Unit of Measure";
                    end;
                end;
                GetDirectCost(FieldNo("No."));
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
        field(10; "Direct Unit Cost"; Decimal)
        {
            Caption = '"Direct Unit Cost"';
            DataClassification = CustomerContent;
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
                GetDirectCost(FieldNo("Unit of Measure Code"));
            end;
        }
        field(12; "Currency Code"; Code[50])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
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
                GetDirectCost(FieldNo(Quantity));
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
        field(16; "Trade agreement exist"; Boolean)
        {
            Caption = 'Trade agreement exist';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckOrderOrQuote();
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
            OptionMembers = Open,Approved,"Pending Approval","Approved-Ordered","Approved-Partially Ordered","Approved-Received","Approved-Partially Received","Approved-Cancel","Aproved-Quote Created","Approved-Partially Quote Created";
        }
        field(26; "Replenishment Type"; Option)
        {
            Caption = 'Replenishment Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Purchase,Transfer;
            OptionCaption = ' ,Purchase,Transfer';
            Editable = false;
        }
        field(27; "Vendors For Quotation"; Integer)
        {
            Caption = 'Vendors For Quotation';
            FieldClass = FlowField;
            CalcFormula = count ("Vendors For Quotations" where("Document No." = field("Document No."),
            "Line No." = field("Line No.")));
        }
        field(28; "Order/Quote"; Option)
        {
            Caption = 'Order/Quote';
            OptionMembers = " ","Purchase Order","Purchase Quote";
            DataClassification = ToBeClassified;
        }
        field(29; "Purchase quote mandatory"; Boolean)
        {
            Editable = false;
            Caption = 'MyField';
            DataClassification = ToBeClassified;
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
        PurchPriceCalcMgt: Codeunit "Requi. Price Calc.";

    procedure TestStatusOpen()
    var
        IndHeaderL: Record "Purchase Indent Header";
    begin
        IndHeaderL.get("Document No.");
        if IndHeaderL."Approval Status" = IndHeaderL."Approval Status"::Released then
            ERROR('Released document cant be changed.');
        //IndHeaderL.TestField("Approval Status", IndHeaderL."Approval Status"::Open);
    end;

    procedure GetDirectCost(CalledByFieldNo: Integer)
    begin
        PurchPriceCalcMgt.FindReqLinePrice(Rec, CalledByFieldNo);
    end;

    procedure LookupVendor(var Vend: Record Vendor; PreferItemVendorCatalog: Boolean): Boolean
    var
        ItemVend: Record "Item Vendor";
        LookupThroughItemVendorCatalog: Boolean;
        IsHandled: Boolean;
        IsVendorSelected: Boolean;
    begin
        if Type = Type::"Fixed Asset" then
            exit(PAGE.RunModal(0, Vend) = ACTION::LookupOK);
        if (Type IN [Type::Item, Type::"Item(Service)"]) and ItemVend.ReadPermission then begin
            ItemVend.Init;
            ItemVend.SetRange("Item No.", "No.");
            //ItemVend.SetRange("Vendor No.", "Vendor No.");
            if "Variant Code" <> '' then
                ItemVend.SetRange("Variant Code", "Variant Code");
            if not ItemVend.FindLast then begin
                ItemVend."Item No." := "No.";
                ItemVend."Variant Code" := "Variant Code";
                ItemVend."Vendor No." := "Vendor No.";
                ItemVend.SetRange("Vendor No.");
                LookupThroughItemVendorCatalog := not ItemVend.IsEmpty or PreferItemVendorCatalog;
            end;
        end;
        LookupThroughItemVendorCatalog := true;
        if LookupThroughItemVendorCatalog then begin
            if PAGE.RunModal(0, ItemVend) = ACTION::LookupOK then
                exit(Vend.Get(ItemVend."Vendor No."));
        end else begin
            Vend."No." := "Vendor No.";
            exit(PAGE.RunModal(0, Vend) = ACTION::LookupOK);
        end;
    end;

    procedure CheckOrderOrQuote()
    var
        PurchSetupL: Record "Purchases & Payables Setup";
    begin
        PurchSetupL.Get();
        if ("Replenishment Type" = "Replenishment Type"::Purchase) then begin
            if ((not "Trade agreement exist") and PurchSetupL."Check Vendor Trade Agreement") or ("Purchase quote mandatory" and PurchSetupL."Quote all") then
                "Order/Quote" := "Order/Quote"::"Purchase Quote"
            else
                "Order/Quote" := "Order/Quote"::"Purchase Order";
        end else
            "Order/Quote" := "Order/Quote"::" ";
    end;

    local procedure CopyFromFixedAsset()
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.Get("No.");
        FixedAsset.TestField(Inactive, false);
        FixedAsset.TestField(Blocked, false);
        Description := FixedAsset.Description;
        "Description 2" := FixedAsset."Description 2";
        "Purchase quote mandatory" := FixedAsset."Quote Mandatory";
        "Trade agreement exist" := true;
    end;
}