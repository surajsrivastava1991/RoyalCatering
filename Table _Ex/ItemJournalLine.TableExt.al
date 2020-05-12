tableextension 50028 "Item Journal Line" extends "Item Journal Line"
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
            TableRelation = "Maintenance Service Line"."Line No." where("MRO No." = field("Reference Document No."), Posted = const(false));
        }

    }
}