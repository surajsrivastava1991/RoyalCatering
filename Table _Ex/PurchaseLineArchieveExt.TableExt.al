tableextension 50058 "Purchase Line Archieve Ext" extends "Purchase Line Archive"
{
    fields
    {
        field(50006; "Technical Sepcification"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Commercial Specification"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50008; "User Comment"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

}