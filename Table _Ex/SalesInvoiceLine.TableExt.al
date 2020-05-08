tableextension 50100 "Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Production Line Created"; Boolean)
        {
            FieldClass = FlowField;
            Editable = false;
        }
        field(50001; "Menu Type"; CODE[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50002; "Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50003; "Monthly Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50004; "Manday Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}