tableextension 50056 "Approval Entry Ext" extends "Approval Entry" //MyTargetTableId
{
    fields
    {
        field(50000; "Document Type 2"; Option)
        {
            Caption = 'Document Type 2';
            OptionMembers = " ",Indent;
            OptionCaption = ' ,Indent';
            DataClassification = CustomerContent;
        }

        /*
                field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ";
        }
        */
    }

}