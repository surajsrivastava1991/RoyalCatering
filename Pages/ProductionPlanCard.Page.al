page 50013 "Production Plan Card"
{
    PageType = Card;
    ApplicationArea = all;
    UsageCategory = Administration;
    SourceTable = "Production Plan Header";
    Caption = 'Production Plan';

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Production Plan No."; "Production Plan No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Kitchen Location"; "Kitchen Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Delivery Date"; "Delivery Date")
                {
                    Caption = 'Delivery Date';
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("BEO No."; "BEO No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("BEO Line No."; "BEO Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Project No."; "Project No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Event Type"; "Event Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'event Type like breakfast, Lunch Dinner etc';
                }

                field("Meal Description"; "Meal Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }

                field("No. of PAX"; "No. of PAX")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Recipe Cost"; "Recipe Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Cost Posted"; "Cost Posted")
                {
                    Caption = 'Cost Posted';
                    ApplicationArea = all;
                    ToolTip = 'For checking that costing has been done or not';
                }

            }
            part(Lines; "Production Plan Subpage")
            {
                Caption = 'Production Planning Lines';
                ApplicationArea = all;
                ToolTip = 'Production Planning Lines';
                SubPageLink = "Production Plan No." = field("Production Plan No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("Copy Document")
            {
                Caption = 'Copy Document';
                action("Get Production Line")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Image = Copy;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        SingleInstanceCodeL: Codeunit "Single Instance";
                    begin
                        SingleInstanceCodeL.SetValue("Production Plan No.");
                        Page.RunModal(50030, Rec);
                    end;
                }
                action("Delivery Note Report")
                {
                    ApplicationArea = all;
                    ToolTip = 'Delivery Note report ';
                    Image = Report;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Report;
                    trigger OnAction()
                    var
                        productionPlanHeaderL: record "Production Plan Header";
                    begin
                        productionPlanHeaderL.Reset();
                        productionPlanHeaderL.SetRange("Production Plan No.", "Production Plan No.");
                        if productionPlanHeaderL.FindFirst() then
                            Report.RunModal(50010, true, true, productionPlanHeaderL);
                    end;
                }


            }
        }
    }
    var
}