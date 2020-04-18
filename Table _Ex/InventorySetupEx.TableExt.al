tableextension 50011 "Inventory Setup Ex" extends "Inventory Setup"
{
    fields
    {
        field(50000; "Kitchen Cost Account"; code[20])
        {
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }

    }
}