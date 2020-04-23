report 50010 "Delivery Note"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/DeliveryNote.rdl';

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
            column(CustomerGName; CustomerG.Name)
            {

            }
            column(CustomerGAdd1; CustomerG.Address)
            { }
            column(CustomerGAdd2; CustomerG."Address 2")
            { }
            column(SalesHeaderG; SalesHeaderG."Event")
            {

            }

            column(VATRegCompInfoG; CompInfoG."VAT Registration No.")
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
            column(Kitchen_Location; SalesHeaderG."kitchen Location Name")
            {

            }
            column(Project_No_; "Project No.")
            {

            }
            column(SalesHeaderGCurrency; SalesHeaderG."Currency Code")
            {

            }
            column(EventDate; SalesHeaderG."Date of function start")
            { }
            column(DayName; DayName)
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
                CompInfoG.CalcFields(Picture);
                SalesHeaderG.Get(SalesHeaderG."Document Type"::Order, "BEO No.");

                CustomerG.get(SalesHeaderG."Sell-to Customer No.");
                DayName := GetWeekDay("Delivery Date");

            end;

            trigger OnPreDataItem()
            begin

            end;
        }
    }



    var
        CompInfoG: record "Company Information";
        SalesHeaderG: Record "Sales Header";
        CustomerG: Record Customer;
        DayName: Text[10];

    Procedure GetWeekDay(var WeekDateP: Date): Text
    var
        DateL: record Date;
    begin
        WITH DateL DO BEGIN
            GET("Period Type"::Date, WeekDateP);
            EXIT("Period Name");
        END;
    end;

}