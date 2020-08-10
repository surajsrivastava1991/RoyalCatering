table 50002 "Cost Allocation Header"
{
    DataClassification = CustomerContent;

    fields
    {

        field(1; "From Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(2; "To Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Bulk Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
            trigger OnValidate()
            var
                LocationL: Record Location;
            begin
                if LocationL.Get("Bulk Location") then
                    "Bulk Location Name" := LocationL.Name
                else
                    "Bulk Location Name" := '';
            end;
        }
        field(4; "Bulk Location Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Bulk Allocation Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(6; "Journal Created"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "Voucher No.(Pre)"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Journal Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Voucher No. (Posted)"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Adjust Cost Item Entry"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Standard Cost Calculation"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Bulk Cost Allocation"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Project Cost Allocation"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Recipe Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum ("Cost Allocation Line"."Recipe Cost" where("from Date" = field("From Date"), "To Date" = field("To Date"), "Bulk Location" = field("Bulk Location")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "From Date", "To Date", "Bulk Location")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
        // if xRec."Journal Posted" then
        //     Error('You cannot modify, because journal has been posted');
    end;

    trigger OnDelete()
    begin
        // if xRec."Journal Posted" then
        //     Error('You cannot delete, because journal has been posted');
    end;

    trigger OnRename()
    begin

    end;

}