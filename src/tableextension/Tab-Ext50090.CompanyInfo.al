tableextension 50090 "Company Info" extends "Company Information"
{
    fields
    {
        field(50000; "Bank Address"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }
}