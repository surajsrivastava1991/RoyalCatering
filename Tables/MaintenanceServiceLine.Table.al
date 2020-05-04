table 50073 "Maintenance Service Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "MRO No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item where("Item Type" = filter('Maintenance Item'));
            trigger OnValidate()
            var
                ItemL: Record Item;
            begin
                if ItemL.Get("Item No.") then
                    UOM := ItemL."Base Unit of Measure"
                else
                    UOM := '';

            end;
        }
        field(4; "UOM"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure" where("Item No." = field("Item No."));
        }
        field(5; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; Date; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Consumption Location"; Code[10])
        {
            TableRelation = Location;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                LocationL: Record Location;
            begin
                if LocationL.Get("Consumption Location") then
                    validate("Project Code", LocationL."Project Code")
                else
                    "Project Code" := '';
            end;

        }
        field(8; "Project Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code;

            trigger OnValidate()
            var
                DimValL: Record "Dimension Value";
                GenLedSetupL: Record "General Ledger Setup";
            begin
                GenLedSetupL.Get();
                DimValL.Reset();
                DimValL.SetRange("Dimension Code", GenLedSetupL."Project Dimension Code :");
                DimValL.SetRange(Code, "Project Code");
                if DimValL.FindFirst() then
                    "Project Description" := DimValL.Name;

            end;
        }
        field(9; "Project Description"; text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Item Ledger Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = true;
            TableRelation = "Item Ledger Entry"."Entry No." where("Reference Document No." = field("MRO No."), "Maintenance Line No." = field("Line No."));
            trigger OnValidate()
            var
                ItemledgerEntryL: Record "Item Ledger Entry";
            begin
                TestField(Posted, false);
                if ItemledgerEntryL.Get("Item Ledger Entry") then begin
                    "Item Ledger Entry Qty." := ItemledgerEntryL.Quantity;
                    ItemledgerEntryL.CalcFields("Cost Amount (Actual)");
                    "Cost Amount(Actual)" := ItemledgerEntryL."Cost Amount (Actual)";
                end else begin
                    "Item Ledger Entry Qty." := 0;
                    "Cost Amount(Actual)" := 0;
                end;

            end;
        }
        field(11; "Item Ledger Entry Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Cost Amount(Actual)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum ("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry No." = field("Item Ledger Entry")));
            Editable = false;
        }
        field(13; "Consumption Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "MRO No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnModify()
    begin
        //  Rec.TestField(Posted, false);
    end;

    trigger OnDelete()
    begin
        if posted then
            Error('You cannot delete the document because few lines has been posted');
    end;

}