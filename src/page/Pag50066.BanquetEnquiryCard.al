page 50066 "Banquet Enquiry Card"
{
    Caption = 'Banquet Enquiry';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Caption = 'BEO No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEditCust(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Type of Sale"; "Type of Sale")
                {
                    Caption = 'Type of Sales';
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Type of Event"; "Type of Event")
                {
                    ApplicationArea = all;
                    ToolTip = 'types of Event';
                }
                field("Event"; "Event")
                {
                    ApplicationArea = all;
                    ToolTip = 'Event';
                }
                field("Details of the event"; "Details of the event")
                {
                    ApplicationArea = all;
                    ToolTip = 'Details of the event';
                }
                field(Segment; Segment)
                {
                    ApplicationArea = all;
                    ToolTip = 'Segment';
                }
                field("Location BEO"; "Location BEO")
                {
                    ApplicationArea = all;
                    ToolTip = 'Location BEO';
                }

                field("Date of function start"; "Date of function start")
                {
                    Caption = 'Date of function start';
                    ApplicationArea = all;
                    ToolTip = 'Date of function start';
                }
                field("Date of function end"; "Date of function end")
                {
                    Caption = 'Date of function end';
                    ApplicationArea = all;
                    ToolTip = 'Date of function end';
                }
                field("Status of event"; "Status of event")
                {
                    ApplicationArea = all;
                    ToolTip = 'Status of event';
                }

                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the name of the salesperson who is assigned to the customer.';
                }
                field("Prepared By"; "Prepared By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Method of Receiving Enquiry"; "Method of Receiving Enquiry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer No.';
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidate(Rec, xRec);
                        CurrPage.Update();
                    end;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Name';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidate(Rec, xRec);

                        CurrPage.Update();
                    end;
                }
                field("Enquiry Contact No."; "Enquiry Contact No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Company / Person Contact No.';
                }
                field("Enquiry Contact Name"; "Enquiry Contact Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Company / Person Contact Name';
                }
                field("Contact Type"; "Contact Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Contract Type for Enquiry stage';
                }

            }

            group("Pricing and Billing")
            {
                grid(MyGrid)
                {
                    group("Pricing and Billing (Revenue Report)")
                    {
                        field("No. of PAX"; "No. of PAX")
                        {
                            ApplicationArea = all;
                            ToolTip = 'Table field';
                        }
                        field("Average Price Per PAX/F&B"; "Average Price Per PAX/F&B")
                        {
                            Caption = 'Price Per PAX/F&B';
                            ApplicationArea = all;
                            ToolTip = 'Table field';
                        }
                        field("Transport (Amount)"; "Transport (Amount)")
                        {
                            ApplicationArea = all;
                            ToolTip = 'Table field';
                        }
                        field("Staff (Amount)"; "Staff (Amount)")
                        {
                            ApplicationArea = all;
                            ToolTip = 'Table field';
                        }
                        field(Miscellaneous; Miscellaneous)
                        {
                            ApplicationArea = all;
                            ToolTip = 'Miscellaneous Amount';
                        }
                    }
                }
            }
        }
    }
}
