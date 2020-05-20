tableextension 50052 "Purch Hdr. Archieve Ext." extends "Purchase Header Archive"
{
    fields
    {
        field(50007; "Ref. Requisition ID"; RecordId)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50008; "Quote Cancelled"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}