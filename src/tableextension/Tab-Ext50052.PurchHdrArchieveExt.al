tableextension 50052 "Purch Hdr. Archieve Ext." extends "Purchase Header Archive"
{
    fields
    {
        field(50007; "Ref. Requisition ID"; RecordId)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50008; "Quotation Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Quotation Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Cancelled;
        }
        field(50009; "Requisition Reference"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}