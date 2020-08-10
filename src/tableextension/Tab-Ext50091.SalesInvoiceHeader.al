tableextension 50091 "Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50060; "Invoice Description"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50063; "Bank Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
        }
    }
}