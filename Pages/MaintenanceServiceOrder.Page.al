page 50073 "Maintenance Service Order"
{
    PageType = Card;
    ApplicationArea = all;
    UsageCategory = Administration;
    SourceTable = "Maintenance Service Header";
    Caption = 'Maintenance Service Order';

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("MRO No."; "MRO No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Asset ID"; "Asset ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Asset Description"; "Asset Description")
                {
                    Caption = 'Asset Description';
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Duration From"; "Duration From")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Duration To"; "Duration To")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Equipment; Equipment)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Location Name"; "Location Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Location of FA Card';
                }

                field("Break Duration"; "Break Duration")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }

                field(Details; Details)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Consequnces; Consequnces)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Correction Action Plan"; "Correction Action Plan")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Preventive action plan"; "Preventive action plan")
                {
                    ApplicationArea = all;
                    ToolTip = 'Location of FA Card';
                }

                field("ManPower Cost"; "ManPower Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }

                field("LPO No."; "LPO No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
            }
            part(Lines; "Maintenance Service Subpage")
            {
                Caption = 'Maintenance Service Lines';
                ApplicationArea = all;
                ToolTip = 'Maintenance Service Lines';
                SubPageLink = "MRO No." = field("MRO No.");
            }
        }
    }
}