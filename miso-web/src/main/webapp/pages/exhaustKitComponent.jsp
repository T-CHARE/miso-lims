<%@ include file="../header.jsp" %>

<%--
  ~ Copyright (c) 2012. The Genome Analysis Centre, Norwich, UK
  ~ MISO project contacts: Robert Davey, Mario Caccamo @ TGAC
  ~ **********************************************************************
  ~
  ~ This file is part of MISO.
  ~
  ~ MISO is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation, either version 3 of the License, or
  ~ (at your option) any later version.
  ~
  ~ MISO is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with MISO.  If not, see <http://www.gnu.org/licenses/>.
  ~
  ~ **********************************************************************
  --%>

<div id="maincontent">
  <div id="contentcolumn">
    <h1>Exhaust a kit component</h1>

    <div id="kitInfo">
    </div>
      <div id="identificationBarcodeForm">
    Scan the identification barcode and press Enter
    <input type="text" name="identificationBarcode" id="identificationBarcode"/>
      </div>

      <div id="locationBarcodeForm" style="display:none">
          New location: (Leave blank if the kit has been used up)
          <input type="text" name="locationBarcode" id="locationBarcode"/>
      </div>
        <br>
      <button type="button" id="exhaustComponentButton" style="display:none">Exhaust</button>
  </div>
</div>

<script>

    var identificationBarcode;


    //press enter to show the rest of the form
    jQuery("#identificationBarcode").keypress(function(e){
        if(e.which==13){
            identificationBarcode = jQuery(this).val();


           getKitInfoByReferenceNumber();



        }

    });

    jQuery("#exhaustComponentButton").click(function(){
            exhaustKitComponent();
    });

    function exhaustKitComponent(){
        var locationBarcode = jQuery("#locationBarcode").val();

        Fluxion.doAjax(
                'kitComponentControllerHelperService',
                'exhaustKitComponent',

                {
                    'identificationBarcode':identificationBarcode,
                    'locationBarcode': locationBarcode,
                    'url': ajaxurl
                },
                {
                    'doOnSuccess': function (json) {

                        alert("The kit component has been successfully exhausted");
                        location.reload(true);
                    }
                });
    }


  function getKitInfoByReferenceNumber(){


      identificationBarcode = jQuery("#identificationBarcode").val();

    Fluxion.doAjax(
            'kitComponentControllerHelperService',
            'getKitInfoByIdentificationBarcode',

            {
              'identificationBarcode':identificationBarcode,
              'url': ajaxurl
            },
            {'doOnSuccess': function (json) {



              if(jQuery.isEmptyObject(json)){
                alert("The identification barcode is not recognised");

              }else if(json.exhausted){
                alert("This kit has already been exhausted");
              }else{

                  console.log(json);
                var htmlStrResult = "<h2>Kit Info </h2><br><b>Name:</b> \t" + json.name +" " + json.componentName +  "<br>" +
                        "<b>Reference Number:</b> \t" + json.referenceNumber + "<br>" +
                        "<b>Lot Number:</b> \t" + json.lotNumber + "<br>" +
                        "<b>Received Date:</b> \t" + json.receivedDate + "<br>" +
                        "<b>Expiry Date:</b> \t" + json.expiryDate + "<br>" +
                        "<b>Location Barcode:</b> \t" + json.locationBarcode + "<br><br><br>";


                  //HIDE/SHOW PARTS OF THE LAYOUT
                  jQuery("#identificationBarcodeForm").hide();
                  jQuery("#locationBarcodeForm").show();
                  jQuery("#exhaustComponentButton").show();

                jQuery('#kitInfo').html(htmlStrResult);

                jQuery('#kitInfo').show();
              }

            }

            });
  };

</script>
<%@ include file="adminsub.jsp" %>

<%@ include file="../footer.jsp" %>