<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" AutoEventWireup="true" CodeBehind="AssignedReports.aspx.cs" Inherits="ManageUPPRM.dashjs.AssignedReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        var myTeamCookie = $.cookie('AssignedReportsMyTeam') ? $.cookie('AssignedReportsMyTeam') : 'my';

        $(document).ready(function () {
            var myTeamSwitch = $('.my-team-switch input.toggle');
            if (myTeamCookie == "team") {
                myTeamSwitch.val("team");
                $('#my-label').removeClass('active');
                $('#team-label').addClass('active');
            } else {
                myTeamSwitch.val("my");
                $('#my-label').addClass('active');
                $('#team-label').removeClass('active');
            };

            $('#report-list-container table').dataTable({
                stateSave: true,
                "aoColumnDefs": [
                    { "searchable": false, "targets": 6 },
                    { "searchable": false, "targets": 7 }
                ]
            });

            $(".reload").click(function () {
                reloadReports();
            });

            $('.my-team-switch input.toggle').on('change', function (event) {
                var myTeamSwitch = $('.my-team-switch input.toggle');

                if (myTeamSwitch.val() == "team") {
                    myTeamSwitch.val("my");
                } else {
                    myTeamSwitch.val("team");
                };

                $.cookie('AssignedReportsMyTeam', myTeamSwitch.val());
                reloadReports();
            });

            $('#show-archived-reports').on('change', function () {
                reloadReports();
            });


            var reloadReports = function () {
                var team = $('.my-team-switch input.toggle').val() == "team";

                callWebService({
                    url: "AssignedReports.aspx/GetReportTemplateAssignments",
                    data: JSON.stringify({ team: team, includeArchived: $('#show-archived-reports').is(':checked') }),
                    success: function (reportAssignments) {
                        $('#report-list-container').html(reportAssignments.d);

                        truncateFields();

                        $('#report-list-container table').dataTable({
                            stateSave: true,
                            "aoColumnDefs": [
                                { "searchable": false, "targets": 6 },
                                { "searchable": false, "targets": 7 }
                            ]
                        });

                        $('.tooltips').tooltip();
                    },
                    blockTarget: $('#report-list-container')
                });
            };

            $('body').on('click', 'a.archive-or-unarchive', function () {
                var reportTemplateAssignmentID = $(this).data('reportTemplateAssignmentId');

                callWebService({
                    data: JSON.stringify({ reportTemplateAssignmentID: reportTemplateAssignmentID }),
                    url: "AssignedReports.aspx/ArchiveOrUnarchiveReportTemplateAssignment",
                    success: function (data) {
                        reloadReports();
                    },
                    blockTarget: $('#report-list-container')
                });

                return false;
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">

            <h3 id="PageTitle" runat="server" class="hide-on-content-only page-title">Assigned Reports
            </h3>

            <div class="page-bar">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="/dashjs/dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Assigned Reports</a>
                    </li>
                </ul>
            </div>

            <div class="row">
                <div id="success-msg" class="alert alert-success span12" style="display: none;">
                </div>
            </div>


            <div class="row margin-top-15">
                <div class="col-md-12">
                    
                    <div class="row">
                        <div class="portlet light bordered" data-team="false">
                            <div class="portlet-title" style="border: none;">
                                <div class="caption">
                                    ASSIGNED REPORTS
                                </div>
                                <div class="tools">
                                    <a href="javascript:;" data-load="true" class="reload"></a>
                                    <a href="javascript:;" class="collapse margin-right-10" data-original-title="" title=""></a>
                                    <%  if (UserIsAdminOrClientAdmin())
                                        { %>
                                    <div class="btn-group my-team-switch" data-toggle="buttons">
                                        <label class="btn btn-default active withTooltip" id='my-label' data-original-title="Show the reports that were assigned to you">
                                            <input type="radio" name="myTeam" value="my" class="toggle"/>
                                            My
                                        </label>
                                        <label class="btn btn-default withTooltip" id="team-label" data-original-title="Show the reports that were assigned to your team">
                                            <input type="radio" name="myTeam" value="team" class="toggle"/>
                                            Team
                                        </label>
                                    </div>
                                    <%} %>
                                </div>
                            </div>

                            <div class="portlet-body" style="position: relative;">
                                <div class="row margin-bottom-15">
                                    <div class="col-md-12">
                                        <div class="md-checkbox-list">
                                            <div class="md-checkbox">
                                                <input type="checkbox" id="show-archived-reports" class="md-check" />
                                                <label for="show-archived-reports">
                                                    <span class="check"></span>
                                                    <span class="box"></span>
                                                    Show Archived Reports
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12" id="report-list-container">
                                        <asp:Literal ID="ReportAssignmentList" runat="server" />
                                    </div>
                                </div>
                                <div class="loading-container"></div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
</asp:Content>
