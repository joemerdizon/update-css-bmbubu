<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUI.Master" CodeBehind="teamOLD.aspx.cs" Inherits="ManageUPPRM.dashjs.team" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->
    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png" />
    <link rel="shortcut icon" href="../assets/ico/favicon.png" />

    <!-- JS -->
    <script src="kaizen/js/kaizenUtils.js"></script>
    
    <!-- support lib for bezier stuff -->
    <script src="jsPlumb/jsBezier-0.6.js"></script>
    <!-- jsplumb util -->
    <script src="jsPlumb/jsPlumb-util.js"></script>
    <!-- base DOM adapter -->
    <script src="jsPlumb/jsPlumb-dom-adapter.js"></script>
    <!-- jsplumb drag-->
    <script src="jsPlumb/jsPlumb-drag.js"></script>
    <!-- main jsplumb engine -->
    <script src="jsPlumb/jsPlumb.js"></script>
    <!-- endpoint -->
    <script src="jsPlumb/jsPlumb-endpoint.js"></script>
    <!-- connection -->
    <script src="jsPlumb/jsPlumb-connection.js"></script>
    <!-- anchors -->
    <script src="jsPlumb/jsPlumb-anchors.js"></script>
    <!-- connectors, endpoint and overlays  -->
    <script src="jsPlumb/jsPlumb-defaults.js"></script>
    <!-- state machine connectors -->
    <script src="jsPlumb/jsPlumb-connectors-statemachine.js"></script>
    <!-- flowchart connectors -->
    <script src="jsPlumb/jsPlumb-connectors-flowchart.js"></script>
    <!-- SVG renderer -->
    <script src="jsPlumb/jsPlumb-renderers-svg.js"></script>
    <!-- canvas renderer -->
    <script src="jsPlumb/jsPlumb-renderers-canvas.js"></script>
    <!-- vml renderer -->
    <script src="jsPlumb/jsPlumb-renderers-vml.js"></script>
    <!-- jquery jsPlumb adapter -->
    <script src="jsPlumb/jquery.jsPlumb.js"></script>
    <!-- /JS -->

















    <style>


/*!
 * Bootstrap v2.3.2
 *
 * Copyright 2013 Twitter, Inc
 * Licensed under the Apache License v2.0
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Designed and built with all the love in the world by @mdo and @fat.
 */


a:focus { outline: thin dotted #333; outline: 5px auto -webkit-focus-ring-color; outline-offset: -2px; }
a:hover, a:active { outline: 0; }
sub, sup { position: relative; font-size: 75%; line-height: 0; vertical-align: baseline; }
sup { top: -0.5em; }
sub { bottom: -0.25em; }
img { width: auto\9; height: auto; max-width: 100%; vertical-align: middle; border: 0; -ms-interpolation-mode: bicubic; }
#map_canvas img, .google-maps img { max-width: none; }
button, input, select, textarea { margin: 0; font-size: 100%; vertical-align: middle; }
button, input {
 *overflow: visible; line-height: normal; }
 button::-moz-focus-inner, input::-moz-focus-inner {
 padding: 0;
 border: 0;
}







/*for team page*/

/*department list*/
/*for search*/
textarea, input[type="text"], input[type="password"], input[type="datetime"], input[type="datetime-local"], input[type="date"], input[type="month"], input[type="time"], input[type="week"], input[type="number"], input[type="email"], input[type="url"], input[type="search"], input[type="tel"], input[type="color"], .uneditable-input { background-color: #929292; border: 0 none; -webkit-box-shadow: 0; -moz-box-shadow: 0; box-shadow: none; -webkit-transition:0; -moz-transition:0; -o-transition:0; transition:0; color:#000; font-size:20px; }
textarea:focus, input[type="text"]:focus, input[type="password"]:focus, input[type="datetime"]:focus, input[type="datetime-local"]:focus, input[type="date"]:focus, input[type="month"]:focus, input[type="time"]:focus, input[type="week"]:focus, input[type="number"]:focus, input[type="email"]:focus, input[type="url"]:focus, input[type="search"]:focus, input[type="tel"]:focus, input[type="color"]:focus, .uneditable-input:focus { border-color: #929292; outline: 0; outline: thin dotted \9; /* IE6-9 */

  -webkit-box-shadow: 0; -moz-box-shadow: 0; box-shadow: none; }
.sidebar input[type="search"] { background:url(../img/sprite.png) 0 -388px no-repeat; background-color:#929292; width:64%; padding:0 18%; height:41px; text-transform:uppercase; }
.sidebar form { margin:0; }
/*flowchart*/
.flowchart { width:100%; display:table; margin:10px 0 0; position:relative; }
.flowchart ul { position:relative; }

#window1{border:5px solid #153a71;}
#chart_div text{ font-family: 'futuracondensed' !important; }
.window { width:185px; min-height:106px; margin:0 auto; background:#999; -webkit-border-radius: 6px; -moz-border-radius: 6px; border-radius: 6px; padding:10px; }


.icon-user { display: block; padding: 0px; margin-right:7px; line-height: 20px; border: 3px solid #fff; -webkit-border-radius: 0px; -moz-border-radius: 0px; border-radius: 0px; -webkit-box-shadow: none; -moz-box-shadow: none; box-shadow: none; -webkit-transition: 0; -moz-transition: 0; -o-transition: 0; transition: 0; width:50px; height:50px; float:left; }
.icon-user:before { content: "" ; }


.thumb_detail { float:left; width:122px; text-align:left; }


.window .row{margin:10px 0 0 0; float:left; width:100%; text-align:center; }
.window-gray .thumb_detail p,
.window .thumb_detail p{text-transform:uppercase;}
.window-gray .thumb_detail h3,
.window .thumb_detail h3{ line-height:25px;}
.filters_users{display:block;}
.filters_users ul{margin:0 auto; display:table; text-align:center;}
.filters_users li{display:block; float:left; margin:0 10px 0 0 !important;}
/*.arrow-down{width:10px; height:80px; position:absolute; top:145px; left:370px; background:url(../img/flow_arrow.png) left bottom no-repeat;}
.line-horizontal{width:675px; height:4px; position:absolute; top:380px; left:100px; background:url(../img/hoz-line.png) left top repeat-x; z-index:0;}
.arrow-down-bottom1{width:10px; height:106px; position:absolute; top:384px; left:97px; background:url(../img/flow_arrow.png) left bottom no-repeat;}
.arrow-down-bottom2{width:10px; height:106px; position:absolute; top:384px; left:320px; background:url(../img/flow_arrow.png) left bottom no-repeat;}
.arrow-down-bottom3{width:10px; height:106px; position:absolute; top:384px; left:545px; background:url(../img/flow_arrow.png) left bottom no-repeat;}
.arrow-down-bottom4{width:10px; height:106px; position:absolute; top:384px; left:768px; background:url(../img/flow_arrow.png) left bottom no-repeat;}*/

.footer-container .span12{margin:0;}
    </style>






    <script type="text/javascript">
        var username = '<%=GetUsername()%>';
    </script>

    <!--  Org Chart Support Code -->
    <script src="js/orgchart.js"></script>
    <script src="../Scripts/jquery.isloading.js"></script>


    <script type="text/javascript">
        function ShowMerit() {
            alert('Coming Soon');
        }

        function SendMessagePopup() {
            $("#SendMessageModal").modal('show');
        }

        function CloseMessageModal() {
            $("#SendMessageModal").modal('hide');
        }

        function SetValue(username, i) {
            $.ajax({
                type: "POST",
                url: "../dashjs/team.aspx/GetScore",
                async: true,
                data: "{username:'" + username + "',cat:'" + i + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var t = "#score" + i;
                    $(t).text(data.d);
                }
            });
        }

        function SetImage(username, i) {
            $.ajax({
                type: "POST",
                url: "../dashjs/team.aspx/GetProgressImage",
                async: true,
                data: "{username:'" + username + "',cat:'" + i + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var t = "#divscore" + i;
                    $(t).css("background-image", "url('" + data.d + "')")
                }
            });
        }

        function ShowLeaderboard() {
            $.ajax({
                type: "POST",
                url: "./team.aspx/BindLeaderboard",
                async: true,
                data: {},
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("#LeaderboardDiv").html('');
                    $("#LeaderboardDiv").html(data.d);
                },
            });
        }

        function ShowSQModal(username) {
            alert('coco');
            openLeaderboard('kaizen/');
            //for (var i = 1 ; i < 6; i++) {
              //  SetValue(username, i);
                //SetImage(username, i);
                //ShowLeaderboard();
            //}
            //$("#SQEEZEModal").modal('show');
        }

        
        function CloseSQModal() {
            $("#SQEEZEModal").modal('hide');
        }

        function ShowMessageModal(userid) {

            touser = parseInt(userid);
            var DTO = { 'userid': touser };

            $.ajax({
                type: "POST",
                url: "../ManageUPWebService.asmx/GetFullName1",
                async: true,
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $('#<%= ToUserFullName.ClientID %>').html(data.d);
                    $("#MessageModal").modal('show');
                },
            });

<%--            $.ajax({
                type: "POST",
                url: "../ManageUPWebService.asmx/GetUserIDFromUserName",
                async: true,
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    touser = parseInt(data.d);
                    DTO = { 'userid': touser };
                    $.ajax({
                        type: "POST",
                        url: "../ManageUPWebService.asmx/GetFullName",
                        async: true,
                        data: JSON.stringify(DTO),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            $('#<%= ToUserFullName.ClientID %>').html(data.d);
                            $("#MessageModal").modal('show');
                        },
                    });
                },
            });--%>
        }

        var touser;

        function SendMessage() {
            var userid = '<%=GetUserID()%>';
                var msgheader = $("#<%=MessageHeader.ClientID%>").val();
                var msgbody = $("#<%=MessageBody.ClientID%>").val();

                var DTO;

                if (touser == userid) {
                    $("#errorbody").html('Cannot send yourself a message');
                    $("#H3").html('Error');
                    $("#SendMessageGeneric").modal('show');
                }
                else {

                    if (msgheader == "" || msgbody == "" || touser == 0) {
                        $("#errorbody").html('Please submit all information.');
                        $("#H3").html('Error');
                        $("#SendMessageGeneric").modal('show');
                    }
                    else {

                        DTO = { 'FromUser': parseInt(userid), 'ToUser': parseInt(touser), 'MessageHeader': msgheader, 'MessageBody': msgbody };

                        $.ajax({
                            type: "POST",
                            url: "../ManageUPWebService.asmx/SendMessageToUser",
                            async: true,
                            data: JSON.stringify(DTO),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data) {
                                if (data.d == true) {
                                    $("#MessageModal").modal('hide');
                                    $("#errorbody").html('Message sent succesfully.');
                                    $("#H3").html('Success');
                                    $("#<%=MessageHeader.ClientID%>").val('');
                                    $("#<%=MessageBody.ClientID%>").val('');
                                    $("#SendMessageGeneric").modal('show');
                                }
                            },
                        });
                    }
                }
            }

            function ShowLoggedStatus(username) {

                DTO = { 'foruser': username };

                $.ajax({
                    type: "POST",
                    url: "../ManageUPWebService.asmx/GetAvailabilityMessage",
                    async: true,
                    data: JSON.stringify(DTO),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        $("#AvailabiltyStatus").html('');
                        $("#AvailabiltyStatus").html(data.d);
                        $("#LoggedModal").modal('show');
                    },
                });
            }

            function GenericComingSoon() {
                $("#GenericComingSoon").modal('show');
            }

            function DismissGenericComingSoon() {
                $("#GenericComingSoon").modal('hide');
            }

            function DeptRedirect(id) {
                var url;
                switch (id) {
                    case 1:
                        url = '../dashjs/radiology.aspx';
                        break;
                }
                document.location.href = url;
            }
    </script>

    <script type="text/javascript">
        //$(document).ready(function () {
        //    $("#accordion").accordion({ active: false, collapsible: true });
        //    //   $("#accordion_inner").accordion();
        //    $('[data-toggle="tab"]').on('shown', function (e) { e.stopPropagation() });
        //});
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div class="page-content-wrapper">
        <div class="page-content">

            <!-- start container -->
            <div class="row">

            <div id="SysMessage" runat="server">
                <h1>Coming soon</h1>
            </div>
            <div id="TeamContainer" runat="server">
                <div class="row-fluid form-horizontal no-left-margin">
                    <div class="fuelux no-left-margin fontsize">
                        <div class="span12">
                            <div class="control-group">
                                <label class="control-label" for="DepartmentSelect">Select Department</label>
                                <div class="controls">
                                    <select id="departmentSelect"></select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="main-container span12" style="overflow: auto; min-height: 650px;">
                    <h2 id="departmentTitle" class="text-center span11" style="padding-bottom: 10px;"></h2>
                    <div id="flowchart" class="flowchart">
                    </div>
                </div>
            </div>
            </div>
        <div></div>
        <div id="SQEEZEModal" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <a href="#" class="close" data-dismiss="modal">&times;</a>
                        <h3 id="H1">Score Chart</h3>
                    </div>

                    <div class="modal-body">
                        <div class="squeeze-container">
                            <h2>Individual Score</h2>
                            <ul>
                                <li>
                                    <div class="level">LEVEL</div>
                                    <div class="progress-bar" id="divscore1">S</div>
                                    <span id="score1"></span></li>
                                <li>
                                    <div class="level">LEVEL</div>
                                    <div class="progress-bar" id="divscore2">QU</div>
                                    <span id="score2"></span></li>
                                <li>
                                    <div class="level">LEVEL</div>
                                    <div class="progress-bar" id="divscore3">E</div>
                                    <span id="score3"></span></li>
                                <li>
                                    <div class="level">LEVEL</div>
                                    <div class="progress-bar" id="divscore4">E</div>
                                    <span id="score4"></span></li>
                                <li>
                                    <div class="level">LEVEL</div>
                                    <div class="progress-bar" id="divscore5">ZE</div>
                                    <span id="score5"></span></li>
                            </ul>
                            <!--end of squeeze-container-->
                        </div>

                        <div class="squeeze-container">
                            <h2>Leaderboard</h2>
                            <div id="LeaderboardDiv">
                                <h3>Generating scores
                                    <img src="img/ajax-loader.gif" /></h3>
                            </div>
                            <%-- <table class="table table-bordered">
                                <tr>
                                    <td>
                                        <h3>SQUEEZE Category</h3>
                                    </td>
                                    <td>
                                        <h3>First (score)</h3>
                                    </td>
                                    <td>
                                        <h3>Second (score)</h3>
                                    </td>
                                    <td>
                                        <h3>Third (score)</h3>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="progress-bar" style="background-image: url('../images/progressimages/100.png')">S</div>
                                    </td>
                                    <td>
                                        <asp:Literal ID="S1" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="S2" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="S3" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="progress-bar" style="background-image: url('../images/progressimages/100.png')">QU</div>
                                    </td>
                                    <td>
                                        <asp:Literal ID="Q1" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="Q2" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="Q3" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="progress-bar" style="background-image: url('../images/progressimages/100.png')">E</div>
                                    </td>
                                    <td>
                                        <asp:Literal ID="E1" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="E2" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="E3" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="progress-bar" style="background-image: url('../images/progressimages/100.png')">E</div>
                                    </td>
                                    <td>
                                        <asp:Literal ID="EE1" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="EE2" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="EE3" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="progress-bar" style="background-image: url('../images/progressimages/100.png')">ZE</div>
                                    </td>
                                    <td>
                                        <asp:Literal ID="Z1" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="Z2" runat="server"></asp:Literal></td>
                                    <td>
                                        <asp:Literal ID="Z3" runat="server"></asp:Literal></td>
                                </tr>
                            </table>--%>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <input type="button" value="Close" class="btn btn-success" onclick="CloseSQModal();" />
                    </div>
                </div>
            </div>
        </div>

        <div id="MessageModal" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h3 id="H2">Send Message</h3>
                    </div>
                    <div class="modal-body">
                        <div>
                            <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-home"></i></a>
                            <a href="#" class="btn btn-small"><i class="icon-file"></i></a>
                            <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-time"></i></a>
                            <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-pencil"></i></a>
                            <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-comment"></i></a>
                            <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-headphones"></i></a>
                        </div>

                        <div style="padding-top: 20px">
                            <h2>Personal Message</h2>
                            <table class="table table-bordered">
                                <tr>
                                    <td>
                                        <div>Send To</div>
                                        <asp:Label ID="ToUserFullName" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div>Title</div>
                                        <asp:TextBox runat="server" ID="MessageHeader" class="form-control" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div>Message</div>
                                        <textarea id="MessageBody" cols="50" rows="5" runat="server" class="form-control"></textarea>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-success" value="Send" onclick="SendMessage();" />
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="SendMessageGeneric" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h3 id="H3"></h3>
                    </div>
                    <div class="modal-body">
                        <p id="errorbody"></p>
                    </div>
                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="LoggedModal" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h3 id="H4">Availablity Status</h3>
                    </div>
                    <div class="modal-body">
                        <h2 id="AvailabiltyStatus"></h2>
                    </div>
                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="GenericComingSoon" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                    </div>
                    <div class="modal-body">
                        <h2>Coming soon...</h2>
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn btn-success" onclick="DismissGenericComingSoon();">OK</a>
                    </div>
                </div>
            </div>
        </div>

</asp:Content>