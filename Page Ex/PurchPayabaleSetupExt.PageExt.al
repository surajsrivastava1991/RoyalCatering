pageextension 50050 "Purch & Payabale Setup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Default Accounts")
        {
            group("Email Body")
            {
                field("Mail Body1"; "Mail Body1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Mail Body2"; "Mail Body2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Mail Body3"; "Mail Body3")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Mail Body4"; "Mail Body4")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Mail Body5"; "Mail Body5")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }

            }
        }
        addbefore("Email Body")
        {
            group(Requisition)
            {
                field("Requisition Nos.(Purchase)"; "Requisition Nos.(Purchase)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Requisition fields';
                }
                field("Requisition Nos.(Transfer)"; "Requisition Nos.(Transfer)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Requisition fields';
                }
                field("Req. Wksh. Template"; "Req. Wksh. Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Requisition fields';
                }
                field("Requisition Wksh. Name"; "Requisition Wksh. Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Requisition fields';
                }
                field("Quote all"; "Quote all")
                {
                    ApplicationArea = All;
                    ToolTip = 'Requisition fields';
                }
                field("Check Vendor Trade Agreement"; "Check Vendor Trade Agreement")
                {
                    ApplicationArea = All;
                    ToolTip = 'Requisition fields';
                }
                field("Item Grouping"; "Item Grouping")
                {
                    ApplicationArea = All;
                    ToolTip = 'Requisition fields';
                }
            }
        }
    }

}