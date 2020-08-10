pageextension 50100 "Sales Order Arch" extends "Sales Order Archive"
{
    layout
    {
        addafter(Status)
        {
            field("Type of Sale"; "Type of Sale")
            {
                Caption = 'Type of Sales';
                ApplicationArea = all;

                ToolTip = 'Table field';
            }
            field("Contact Type"; "Contact Type")
            {
                ApplicationArea = all;
                ToolTip = 'Contract Type';
                Editable = false;
            }
            field("Sell-to Phone No."; "Sell-to Phone No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Phone No.';
                Importance = Additional;
                ToolTip = 'Specifies the phone number of the contact that the sales document will be sent to.';
            }
            field("Sell-to E-Mail"; "Sell-to E-Mail")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Email';
                Importance = Additional;
                ToolTip = 'Specifies the email address of the contact that the sales document will be sent to.';
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

            field("Project Location Name"; "Project Location Name")
            {
                ApplicationArea = all;

                ToolTip = 'Table field';
            }
            field("kitchen Location"; "kitchen Location")
            {
                ApplicationArea = all;

                ToolTip = 'Table field';
            }
            field("kitchen Location Name"; "kitchen Location Name")
            {
                ApplicationArea = all;

                ToolTip = 'Table field';
            }
            field("Status of event"; "Status of event")
            {
                ApplicationArea = all;
                ToolTip = 'Table field';
                Editable = false;
            }
            field("Banquet Order Status"; "Banquet Order Status")
            {
                ApplicationArea = all;
                Editable = true;
                ToolTip = 'Banquet Order status , where system will generate archive';
            }
            field("No. of Archived Versions"; "No. of Archived Versions")
            {
                Caption = 'Revision';
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies the number of archived versions for this document.';
            }

            field("Date of function start"; "Date of function start")
            {
                ApplicationArea = all;

                ToolTip = 'Table field';
            }
            field("Date of function end"; "Date of function end")
            {
                ApplicationArea = all;

                ToolTip = 'Table field';
            }
            field("Start Time"; "Start Time")
            {
                MultiLine = true;
                ApplicationArea = all;

                ToolTip = 'Table field';
            }
            field("End Time"; "End Time")
            {
                MultiLine = true;
                ApplicationArea = all;

                ToolTip = 'Table field';
            }
        }
        addafter(General)
        {
            group("Event Info")
            {
                field("Event"; "Event")
                {
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Details of the event"; "Details of the event")
                {
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Type of Event"; "Type of Event")
                {
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Segment; Segment)
                {
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Venue; Venue)
                {
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Location BEO"; "Location BEO")
                {
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Service Delivery"; "Service Delivery")
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Service Style"; "Service Style")
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
            }
            group(Guests)
            {
                grid(MyGrid1)
                {
                    group(GuestControl)
                    {
                        ShowCaption = false;
                        field("Guest Guaranteed"; "Guest Guaranteed")
                        {
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                            MultiLine = true;
                        }
                        field("Guest Expected"; "Guest Expected")
                        {
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                            MultiLine = true;
                        }
                        field("HK Lines"; "HK Lines")
                        {
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                        }
                    }
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
                    group("Pricing and Billing (Invoice)")
                    {
                        field("Menu Price"; "Menu Price")
                        {
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                        }
                        field(Pricing; Pricing)
                        {
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                            MultiLine = true;
                        }
                        field("Billing Instruction"; "Billing Instruction")
                        {
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                            MultiLine = true;
                        }
                    }
                }
            }
            group("Food and Beverage")
            {
                grid(MyGrid2)
                {
                    group("Food Menu")
                    {
                        field("Food Menu1"; "Food Menu1")
                        {
                            ShowCaption = false;
                            MultiLine = true;
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                        }
                        field("Food Menu2"; "Food Menu2")
                        {
                            ShowCaption = false;
                            multiline = true;
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                        }
                        field("Food Menu3"; "Food Menu3")
                        {
                            ShowCaption = false;
                            MultiLine = true;
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                        }
                    }
                    group(Beverages)
                    {
                        field(Beverages1; Beverages1)
                        {
                            ShowCaption = false;
                            multiline = true;
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                        }
                        field(Beverages2; Beverages2)
                        {
                            ShowCaption = false;
                            multiline = true;
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                        }
                        field("Food & Beverages Notes"; "Food & Beverages Notes")
                        {
                            multiline = true;
                            ApplicationArea = all;

                            ToolTip = 'Table field';
                        }
                    }
                }

            }
            group("Setup and Equipment Notes")
            {
                field(Kitchen; Kitchen)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Equipment; Equipment)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Stewarding; Stewarding)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Restrictions; Restrictions)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Setup Notes"; "Setup Notes")
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Staffing; Staffing)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Housekeeping; Housekeeping)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Transportation; Transportation)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Engineering; Engineering)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Additional Instructions"; "Additional Instructions")
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field(Hygiene; Hygiene)
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Reffered By"; "Reffered By")
                {
                    MultiLine = true;
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                }
                field("Modified Fields"; "Modified Fields")
                {
                    ApplicationArea = all;

                    ToolTip = 'Table field';
                    MultiLine = true;
                }
            }
        }
    }
}
