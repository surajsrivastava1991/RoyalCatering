tableextension 50050 "Purchase & Payable Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Mail Body1"; Text[100])
        {
            DataClassification = CustomerContent;

        }
        field(50001; "Mail Body2"; Text[100])
        {
            DataClassification = CustomerContent;

        }
        field(50002; "Mail Body3"; Text[100])
        {
            DataClassification = CustomerContent;

        }
        field(50003; "Mail Body4"; Text[100])
        {
            DataClassification = CustomerContent;

        }
        field(50004; "Mail Body5"; Text[100])
        {
            DataClassification = CustomerContent;

        }

        field(50005; "Requisition Nos.(Purchase)"; Code[20])
        {
            Caption = 'Requisition Nos.(Purchase)';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

        }
        field(50006; "Req. Wksh. Template"; Code[10])
        {
            Caption = 'Req. Wksh. Template';
            DataClassification = CustomerContent;

            TableRelation = "Req. Wksh. Template";
            ValidateTableRelation = true;
        }
        field(50007; "Requisition Wksh. Name"; Code[10])
        {
            Caption = 'Requisition Wksh. Name';
            DataClassification = CustomerContent;

            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("Req. Wksh. Template"));
            ValidateTableRelation = true;
        }
        field(50008; "Requisition Nos.(Transfer)"; Code[20])
        {
            Caption = 'Requisition Nos.(Transfer)';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

        }
        field(50009; "Quote all"; Boolean)
        {
            Caption = 'Quote all';
            DataClassification = CustomerContent;

        }
        field(50010; "Check Vendor Trade Agreement"; Boolean)
        {
            Caption = 'Check Vendor Trade Agreement';
            DataClassification = CustomerContent;
        }
        field(50011; "Item Grouping"; Boolean)
        {
            Caption = 'Item Grouping';
            DataClassification = CustomerContent;
        }
        // field(50012; "Requisition No."; Code[20])
        // {
        //     TableRelation = "No. Series";
        //     DataClassification = CustomerContent;
        // }
        field(50012; "Group on Delivery Date"; Boolean)
        {
            Caption = 'Group on Delivery Date';
            DataClassification = CustomerContent;
        }
    }
}