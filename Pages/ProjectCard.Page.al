page 50007 "Project Card"
{
    PageType = Card;
    SourceTable = Job;
    Caption = 'Project Card';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Kitchen Location"; "Kitchen Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Kitchen Location Name"; "Kitchen Location Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Project Location"; "Project Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Project Location Name"; "Project Location Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Project Status"; "Project Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Project Description"; "Project Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("Projects")
            {
                action("&Dimensions")
                {
                    ApplicationArea = Dimensions;
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(167),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.';
                }
                action("&Statistics")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    RunObject = Page "Job Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View this job''s statistics.';
                }
                separator(Action64)
                {
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category7;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Job),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action("&Online Map")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Online Map';
                    Image = Map;
                    ToolTip = 'View online map for addresses assigned to this job.';

                    trigger OnAction()
                    begin
                        DisplayMap();
                    end;
                }
                action(Attachments)
                {
                    ApplicationArea = all;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category7;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Attachment Document";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
        }
        // Add changes to page actions here
    }

}