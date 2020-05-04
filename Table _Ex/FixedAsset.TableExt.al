tableextension 50070 "Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(50000; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item where("Item Type" = filter('Fixed Asset'));
        }
    }
}