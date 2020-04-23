report 50009 "Cost Allocation Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/CostAllocation.rdl';

    dataset
    {
        dataitem("Production Plan Header"; "Production Plan Header")
        {
            column(CompanyDetailsName; CompInfoG.Name)
            {

            }
            column(Logo; CompInfoG.Picture)
            { }
            column(CompInfoGAdd; CompInfoG.Address)
            {

            }
            column(VATRegCompInfoG; CompInfoG."VAT Registration No.")
            {

            }
            column(StartDate; StartDate)
            {

            }
            column(Enddate; Enddate)
            {

            }

            column(Delivery_Date; "Delivery Date")
            { }
            column(Event_Type; "Event Type")
            { }
            column(BEO_No_; "BEO No.")
            {

            }
            column(BEO_Line_No_; "BEO Line No.")
            {

            }

            column(No__of_PAX; "No. of PAX")
            {

            }
            column(Recipe_Cost; "Recipe Cost")
            {

            }
            column(Kitchen_Location; "Kitchen Location")
            {

            }
            column(Project_No_; "Project No.")
            {

            }
            column(salesHeaderGProjectName; salesHeaderG."Project Description")
            {

            }
            column(ProjectDescriptionEnable; ProjectDescriptionG)
            {

            }
            dataitem("Production Plan Line"; "Production Plan Line")
            {
                DataItemTableView = sorting("Production Plan No.", "Line No.");
                DataItemLinkReference = "Production Plan Header";
                DataItemLink = "Production Plan No." = field("Production Plan No.");
                column(Production_Plan_No_; "Production Plan No.")
                {

                }
                column(Line_No_; "Line No.")
                {

                }
                column(Item_No_; "Item No.")
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Description; Description)
                {

                }
                column(UOM; UOM)
                {

                }
                column(Recipe_Costl; "Recipe Cost")
                {

                }
                column(Line_Amount; "Line Amount")
                {

                }
            }

            trigger OnAfterGetRecord()
            begin
                CompInfoG.get();
                salesHeaderG.Get(salesHeaderG."Document Type"::Order, "BEO No.");
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Delivery Date", StartDate, Enddate);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Date Filter")
                {
                    field(StartDate; StartDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;
                        ToolTip = 'Delivery Date Filter';
                    }

                    field(Enddate; Enddate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = All;
                        ToolTip = 'Delivery Date Filter';

                    }
                    group(General)
                    {
                        field(ProjectDescriptionG; ProjectDescriptionG)
                        {
                            Caption = 'Project Description wise Grouping';
                            ApplicationArea = All;
                            ToolTip = 'Instead of Project Code ,Project Description will come';
                        }
                    }
                }
            }
        }
    }


    var
        CompInfoG: record "Company Information";
        salesHeaderG: Record "Sales Header";
        StartDate: Date;
        Enddate: Date;
        ProjectDescriptionG: Boolean;

    procedure DateFilter(var StartDateP: Date; var EndDateP: Date)
    begin
        StartDate := StartDateP;
        Enddate := EndDateP;
    end;


}