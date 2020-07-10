tableextension 50125 "Transfer Ship Line" extends "Transfer Shipment Line"
{
    fields
    {
        field(50000; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        // Add changes to table fields here
    }
}