tableextension 50029 "Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "Reference Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Maintenance Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
}