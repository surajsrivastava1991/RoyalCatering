tableextension 50008 "Location Type" extends Location
{
    fields
    {
        field(50000; "Location Type"; Option)
        {
            OptionMembers = " ","Bulk Kitchen","Project Kitchen";
            OptionCaption = ' ,Bulk Kitchen,Project Kitchen';
            DataClassification = CustomerContent;
        }
        field(50001; "Project Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code;
        }
        field(50002; "Item Template Name"; code[10])
        {
            Caption = 'Item Template Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Template" where(Type = filter('Item'));
        }
        field(50003; "Item Batch Name"; Code[10])
        {
            Caption = 'Item Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Item Template Name"));
            trigger OnValidate()
            begin
                TestField("Item Template Name");
            end;
        }
        field(50004; "Warehouse/Store Incharge Email"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50005; "Journal Template Name"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(50006; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
            trigger OnValidate()
            begin
                TestField("Journal Template Name");
            end;
        }
        field(50007; "Reject Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(50008; "Transfer Template Name"; code[10])
        {
            Caption = 'Transfer Template Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Template" where(Type = filter('Transfer'));
        }
        field(50009; "Transfer Batch Name"; Code[10])
        {
            Caption = 'Transfer Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Transfer Template Name"));
            trigger OnValidate()
            begin
                TestField("Item Template Name");
            end;
        }
    }
}