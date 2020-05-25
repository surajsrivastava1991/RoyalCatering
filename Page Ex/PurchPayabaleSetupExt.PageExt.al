pageextension 50050 "Purch & Payabale Setup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Default Accounts")
        {
            group("Email Body")
            {
                field(Salutation; Salutation)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Body Line1"; "Body Line1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    MultiLine = true;
                }
                field("Body Line2"; "Body Line2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    MultiLine = true;

                }
                field(Thanking; Thanking)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Visible = true;
                }
                field("Person Singnature"; "Person Singnature")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Visible = true;
                }
                field("Signature (Company Name)"; "Signature (Company Name)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Singnature 1"; "Singnature 1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Singnature 2"; "Singnature 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Singnature 3"; "Singnature 3")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Visible = true;
                }
                field("Signature Image"; "Signature Image")
                {
                    ApplicationArea = all;
                    ToolTip = 'Signature Image';
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
                field("Item Grouping"; "Item Grouping")
                {
                    ApplicationArea = All;
                    ToolTip = 'Requisition fields';
                }
                group("Purchase Quotes")
                {
                    field("Quote all"; "Quote all")
                    {
                        Caption = 'Purchase Quote Mandatory';
                        ApplicationArea = All;
                        ToolTip = 'Requisition fields';
                    }
                    field("Check Vendor Trade Agreement"; "Check Vendor Trade Agreement")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Requisition fields';
                    }
                }
            }
        }
        addafter("Email Body")
        {
            group("Quote Email Body")
            {
                field(Quote_Salutation; Quote_Salutation)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Quote_Body Line1"; "Quote_Body Line1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    MultiLine = true;
                }
                field("Quote_Body Line2"; "Quote_Body Line2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    MultiLine = true;

                }
                field(Quote_Thanking; Quote_Thanking)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Visible = true;
                }
                field("Quote_Person Singnature"; "Quote_Person Singnature")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Visible = true;
                }
                field("Quote_Signature (Company Name)"; "Quote_Signature (Company Name)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Quote_Singnature 1"; "Quote_Singnature 1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Quote_Singnature 2"; "Quote_Singnature 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Quote_Singnature 3"; "Quote_Singnature 3")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Visible = true;
                }
                field("Quote_Signature Image"; "Quote_Signature Image")
                {
                    ApplicationArea = all;
                    ToolTip = 'Signature Image';
                }

            }
        }
    }

}