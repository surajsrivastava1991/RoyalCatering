pageextension 50009 "Location Cost Card" extends "Location Card"
{
    layout
    {
        addafter(General)
        {
            group("Royal Catering")
            {
                field("Location Type"; "Location Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Project Code"; "Project Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Item Template Name"; "Item Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Item Batch Name"; "Item Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Warehouse/Store Incharge Email"; "Warehouse/Store Incharge Email")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Reject Location"; "Reject Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'All rejected quantity while doing GRN, will accept here ';
                }
                field("Transfer Template Name"; "Transfer Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Template For rejected quantity transfer in rejected location';
                }
                field("Transfer Batch Name"; "Transfer Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Batch for rejected quantity transfer in rejected location';
                }
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
}