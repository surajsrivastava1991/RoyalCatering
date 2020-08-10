tableextension 50082 "GenJnlBatchExt" extends "Gen. Journal Batch"
{
    fields
    {
        field(60000; "Description 2"; text[80])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(60001; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
            OptionMembers = "Open","Sent for Approval","Approved","Canceled","Rejected";
            OptionCaption = 'Open,Sent for Approval,Approved,Canceled,Rejected';
            Editable = false;
        }
        field(60003; "Allow Multiple Voucher"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Allow Multiple Voucher';
        }
        field(60004; "Voucher Name"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Voucher Name';
        }

    }
}