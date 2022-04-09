<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="leaderboard.aspx.cs" Inherits="ManageUPPRM.dashjs.leaderboard" %>

<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="CalendarEventForm" Src="~/UserControls/CalendarEventForm.ascx" %>
<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="" />
    <meta name="author" content="" />

    <link href="../dashjs/css/kendo.common.min.css" rel="stylesheet" />
    <link href="../dashjs/css/kendo.default.min.css" rel="stylesheet" />

    <script src="js/Kendo.all.min.js"></script>
    <script src="../dashjs/js/fuelUx/scheduler.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('.input-daterange').datepicker({ todayHighlight: true });

        });
    </script>

    <script type="text/javascript">

        var aspxPage = 'kaizen/kaizen.aspx';

        $(document).ready(function () {
            var firstUserSelected = $('#<%=users.ClientID%>');

            firstUserSelected.find('.selected-users').on('change', function () {
                getLeaders(_department, _allTime);
            });

            $('.input-daterange').on('change', function () {
                getLeaders(_department, _allTime);
            });

            getLeaders(_department, false);

            //$('form').on('keypress', function(e){
            //if(e.keyCode==13)
            //{
            //  getLeaders(_department,_allTime);
            //return false; 
            //}
            //});
        });

        function doEnter(ev) {
            if (window.event.keyCode == 13) {
                getLeaders(_department, _allTime);
            }
        }

        var _department = 1;
        var _allTime = false;

        function callLeadersDepartment(department) {
            _department = department
            getLeaders(department, false)
        }

        function doSelectRole() {
            var role = $('#cmbRoles').val();
            getLeaders(_department, _allTime);
        }

        function callLeadersAllTime() {
            _allTime = true;
            getLeaders(_department, true)
        }

        function getLeaders(department, allTime) {
            //int departmentId, Boolean allTime, int userTitleId
            var filter = '';
            //var filter = $('#txtSearch').val();
            var role = $('#cmbRoles').val();


            var users = getSelectedUsers($('#<%=users.ClientID%>'));
            //alert(users);
            var fromDate = $('#DateFrom').val();
            var toDate = $('#DateTo').val();

            //alert(fromDate);

            var params = '{ "fromDate": "' + fromDate + '", "toDate": "' + toDate + '", "users": "' + users + '", "departmentId": ' + department + ', "allTime": ' + allTime + ', "userTitleId": 0, "filter": "' + filter + '" }';
            //alert(params);
            callActionOnServer('getLeaderboard', params, true, true, loadTable);
            //$('#modalLeaderboard').modal('show');

        }

        function loadTable(result) {
            $('#leadersList').html($('#leaderboard-content').tmpl(result));
        }

        function callActionOnServer(action, params, showLoading, hideLoading, onSuccess) {
            call(aspxPage + "/" + action, params, function (result) { onSuccess(result.d) });
        }

        function processLoading() {
            //$("#loading-modal").modal('show');

        }


        function endProcessLoading() {
            //$("#loading-modal").modal('hide');
        }

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-content-wrapper">
        <div class="page-content">

            <h3 class="hide-on-content-only page-title tooltips col-md-2" data-placement="auto left" data-original-title="Leaderboard reflects the number of points obtained by each user during this date range.">Leaderboard</h3>
            <!-- start search -->
            <div class="row">
                <div class="col-md-12 bottom-padding">

                    <div class="col-md-6">
                        <div class="input-group input-large date-picker input-daterange form-group" data-date="" data-date-format="mm/dd/yyyy">
                            <input type="text" class="form-control" name="from" id="DateFrom" runat="server" />
                            <span class="input-group-addon">to </span>
                            <input type="text" class="form-control" name="to" id="DateTo" runat="server" />
                        </div>

                    </div>
                    <!-- search box -->
                    <%--<div>
                        <div class="playbook-search col-md-5">
                            <!-- input -->
                            <div class="input-icon pull-right search-field">
                                <i class="fa fa-search"></i>
                                <input name="txtSearch" id="txtSearch" class="form-control pull-right" placeholder="Search" type="text" />
                            </div>
                        </div>
                        <div class="playbook-search col-md-1">
                            <input type="button" value="Search" class="btn green" onclick="getLeaders(_department, _allTime);" />
                        </div>
                        <div class="clearfix"></div>
                        <!-- end search box -->

                    </div>--%>
                </div>
            </div>
            <!-- end search -->

            <!-- DEVELOPER NOTICE (PLAYBOOK) CLASS HERE -->
            <div class="row playbook">


                <!-- start column 1 ////////////////////////////// -->
                <div class="col-md-12">


                    <!-- BEGIN TABBED PORTLET -->
                    <div class="portlet light">

                        <!-- start taps TOP -->
                        <div class="portlet-title tabbable-line" style="border: none; margin-bottom: 0;">


                            <!-- start filter -->
                            <div class="pull-right leaderboard-filter">
                                <div class="form-group no-bottom withTooltip" data-original-title="Custom select the users you want to view on this Leaderboard.">
                                    <uc:UsersGroup runat="server" ShowGroupNames="false" ID="users" />
                                </div>
                            </div>
                            <!-- end filter -->


                            <!-- start -->
                            <ul class="nav nav-tabs report-tabs">

                                <!-- tab 1 -->
                                <li class="active">
                                    <a href="#department_tab_1" data-toggle="tab" onclick="callLeadersDepartment(1);">
                                        <i class="fa fa-stethoscope"></i>
                                        Department </a>
                                </li>

                                <!-- tab 2 -->
                                <li>
                                    <a href="#entire_organization_tab_2" data-toggle="tab" onclick="callLeadersDepartment(0);">
                                        <i class="fa fa-hospital-o"></i>
                                        Entire Organization </a>
                                </li>

                                <!-- tab 3 -->
                                <li>
                                    <a href="#all_time_tab_3" data-toggle="tab" onclick="callLeadersAllTime();">
                                        <i class="fa fa-trophy"></i>
                                        All Time </a>
                                </li>

                                <!-- tab 4 -->
                                <%--<li>
                                    <a href="#blitz_tab_4" data-toggle="tab" onclick="getLeaders();">
                                        <i class="fa fa-bolt"></i>
                                        Blitz </a>
                                </li>--%>

                            </ul>
                        </div>
                        <!-- end taps TOP -->



                        <!-- ////////////////////// CONTENT ///////////////////////////////////////////// -->
                        <div class="portlet box">
                            <div class="portlet-body">
                                <div class="tab-content">



                                    <!-- ////////////////////// START CONTENT TAB 1 ///////////////////////////////////////////// -->
                                    <div class="tab-pane leaderboard-table active" id="department_tab_1">

                                        <table class="table table-striped table-bordered table-hover" id="department_table">
                                            <thead>
                                                <tr>
                                                    <th class="col-md-2 text-center"><span class="tooltips" data-original-title="This is an example tooltip!">SQUEEZE</span> </th>
                                                    <th class="col-md-2 text-center"><span class="tooltips" data-original-title="This is an example tooltip!">Safety</span> </th>
                                                    <th class="col-md-2 text-center"><span class="tooltips" data-original-title="This is an example tooltip!">Quality</span> </th>
                                                    <th class="col-md-2 text-center"><span class="tooltips" data-original-title="This is an example tooltip!">Effectiveness</span> </th>
                                                    <th class="col-md-2 text-center"><span class="tooltips" data-original-title="This is an example tooltip!">Efficiency</span> </th>
                                                    <th class="col-md-2 text-center"><span class="tooltips" data-original-title="This is an example tooltip!">Zest</span> </th>
                                                </tr>
                                            </thead>
                                            <tbody id="leadersList">

                                                <!-- ////// query loop start -->
                                                <!-- ////// 
										DEVELOPER NOTICE!
										1: THE INDIVIDUAL USER SCORES HAS A CLASS CALLED "MY-SCORES"
										1B: EVERYONE ELSE DOES NOT HAVE THIS CLASS

										2: THE COMMENT IN THE TD IS NEEDED FOR ORDERING!
										2B: MY SCORE SHOULD BE 0, EVERYONE ELSE CAN BE ORDERED NUMERICALLY
									-->


                                            </tbody>
                                        </table>

                                    </div>
                                    <!-- ////////////////////// END CONTENT TAB 1 ///////////////////////////////////////////// -->







                                </div>
                            </div>
                        </div>
                        <!-- ////////////////////// END CONTENT ///////////////////////////////////////////// -->

                    </div>

                </div>
                <!-- end column 1 ////////////////////////////// -->


            </div>

            <script type="text/x-jquery-tmpl" id="leaderboard-content">
				<tr {{if position == 0 }} class="my-scores" {{/if}}>
                    <td class="col-md-2 text-center"> {{if position == 0 }} My scores {{/if}} {{if position > 0 }} <i class="fa fa-star"></i>  #${position} {{/if}}</td>
					<td class="col-md-2 text-center">{{if scores[0] != null }} {{if position != 0 }} <span> ${scores[0].user.name} </span><br /> {{/if}} (${scores[0].score}){{/if}}</td>
					<td class="col-md-2 text-center">{{if scores[1] != null }} {{if position != 0 }} <span> ${scores[1].user.name} </span><br /> {{/if}} (${scores[1].score}){{/if}}</td>
					<td class="col-md-2 text-center">{{if scores[2] != null }} {{if position != 0 }} <span> ${scores[2].user.name} </span><br /> {{/if}} (${scores[2].score}){{/if}}</td>
					<td class="col-md-2 text-center">{{if scores[3] != null }} {{if position != 0 }} <span> ${scores[3].user.name} </span><br /> {{/if}} (${scores[3].score}){{/if}}</td>
					<td class="col-md-2 text-center">{{if scores[4] != null }} {{if position != 0 }} <span> ${scores[4].user.name} </span><br /> {{/if}} (${scores[4].score}){{/if}}</td>
				</tr>
            </script>



            <!--                                <div class="row datacontainer-leaderboard">
                        <div class="col-cus-3 leaderboard-right-seperator   "><input type="button" value="${categoryName}" class="button-modal-leaderboard"> </div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[0] != null }} ${scores[0].user.name} <br/>(${scores[0].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[1] != null }} ${scores[1].user.name} <br/>(${scores[1].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[2] != null }} ${scores[2].user.name} <br/>(${scores[2].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[3] != null }} ${scores[3].user.name} <br/>(${scores[3].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[4] != null }} ${scores[4].user.name} <br/>(${scores[4].score}) {{/if}}</div>
                        </div>




    									<tr class="my-scores">
										<td> My Scores </td>
										<td>  <span>Jay Strouse</span><br />(800)</td>
										<td> <span>Jay Strouse</span><br />(800)</td>
										<td> <span>Jay Strouse</span><br />(800)</td>
										<td> <span>Jay Strouse</span><br />(800)</td>
										<td> <span>Jay Strouse</span><br />(800)</td>
									</tr>

									<tr>
										<td> <i class="fa fa-star"></i> 1st </td>
										<td> <span>Dan Kouba</span><br />(800)</td>
										<td> <span>Dan Kouba</span><br />(800)</td>
										<td> <span>Dan Kouba</span><br />(800)</td>
										<td> <span>Dan Kouba</span><br />(800)</td>
										<td> <span>Dan Kouba</span><br />(800)</td>
									</tr>

									<tr>
										<td>  <i class="fa fa-star"></i> 2nd </td>
										<td> <span>Lilli Kouba</span><br />(800)</td>
										<td> <span>Lilli Kouba</span><br />(800)</td>
										<td> <span>Lilli Kouba</span><br />(800)</td>
										<td> <span>Lilli Kouba</span><br />(800)</td>
										<td> <span>Lilli Kouba</span><br />(800)</td>
									</tr>

-->

        </div>
    </div>
    <!-- end container -->

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:UsersGroupModal runat="server" ID="UsersGroupModal"></uc:UsersGroupModal>
</asp:Content>
