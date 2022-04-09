<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUI.Master" CodeBehind="mydocs.aspx.cs" Inherits="ManageUPPRM.mydocs" %>

<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        if (window.location.hash) {
            var selectedTab = '<%=AssignmentStatusReportTab.ClientID%>';
        } else {
            var selectedTab = $.cookie('GenerateReportsSelectedTab') ? $.cookie('GenerateReportsSelectedTab') : 'favorites-tab';
        }

        var documentToDownloadURL;

        $(function () {
            $(document).ready(function () {
                $("#" + selectedTab).find('a').click();

                $(".nav-tabs li").on('shown.bs.tab', function (e) {
                    var id = $(this).attr('id');
                    $.cookie('GenerateReportsSelectedTab', id);
                });
            });

            $("#ReportsLog").DataTable({ stateSave: true });
            $("#ReportsLogMulti").DataTable({ stateSave: true });
            $('select').select2();
            $('.input-daterange').datepicker({ todayHighlight: true });
            
            //Set Report Type Radio on Assignment Status Report
            <%if (Request.QueryString["ReportTemplateAssignmentID"] != null && Request.QueryString["Team"] == "1"){%>
                var radio = $("#reportTypeRadioMultiUserReport").prop('checked', true);
                $.uniform.update(radio);
                toggleAssignmentStatusEmployeesContainers();
            <%} else {%>
                var radio = $("#reportTypeRadioSingleUserReport").prop('checked', true);
                $.uniform.update(radio);
            <%}%>


            //Disable admin related user controls from Assignment Status Report
            <%if (!UserIsAdminOrClientAdmin())
            {%>
                $('.assignment-status-admin-control').prop('disabled', true);
            <%}%>


            //Load users and trigger Assignment Status Report
            <%if (Request.QueryString["ReportTemplateAssignmentID"] != null)
            {%>
                var triggerAssignmentStatusReport = function () {
                    $("#AssignmentStatusEmployeesSingle").val("<%=getUserId()%>").trigger("change");
                    $('#GenerateAssignmentStatusReport').trigger('click');
                }
                
                loadAssignmentStatusUsers(triggerAssignmentStatusReport);
            <%} else {%>
                loadAssignmentStatusUsers();
            <%}%>



            var reportModal = $('#view-report-modal');
            var iframe = reportModal.find('iframe');
            iframe.load(function () {
                iframe.show();
                Metronic.unblockUI('#view-report-modal .modal-body');
            });

            $('#GenerateMultiUserReport').on('click', function () {
                var selectedUsers = $('#<%=ClientUserListMultiple.ClientID%> .selected-users').val();
                var reportModal = $('#view-multi-report-modal');

                if ($('#DocumentSelectionMultiUser').val() == '0' || selectedUsers == '0') {
                    return;
                };
                Metronic.blockUI({ target: '#view-multi-report-modal .modal-body', cenrerY: true, animate: true });

                var iframe = reportModal.find('iframe');
                iframe.load(function () {
                    iframe.show();
                    Metronic.unblockUI('#view-multi-report-modal .modal-body');
                });

                reportModal.data('docid', $('#DocumentSelectionMultiUser').val())
                            .data('datefrom', $('#<%=DateFromMulti.ClientID%>').val())
                            .data('dateto', $('#<%=DateToMulti.ClientID%>').val())
                            .data('documentname', $('#DocumentSelectionMultiUser option:selected').text());


                var url = "/dashjs/admin/MultiUserReport.aspx?reportID=" + $('#DocumentSelectionMultiUser').val() + "&selectedUsers=" + selectedUsers + "&dateFrom=" + $('#<%=DateFromMulti.ClientID%>').val() + "&dateTo=" + $('#<%=DateToMulti.ClientID%>').val();
                iframe.prop('src', url).css('height', ($(window).height() - 180) + 'px');
                iframe.hide();

                reportModal.modal('show');

                return false;
            });

            $('#GenerateDocument').on('click', function () {

                if ($('#DocumentSelection').val() == '0' || $('#ClientUsersList').val() == '0') {
                    return;
                };

                iframe.hide();
                reportModal.data('docid', $('#DocumentSelection').val())
                            .data('belongsto', $('#ClientUsersList').val())
                            .data('datefrom', $('#<%=DateFrom.ClientID%>').val())
                            .data('dateto', $('#<%=DateTo.ClientID%>').val())
                            .data('documentname', $('#DocumentSelection option:selected').text());
                
                Metronic.blockUI({ target: '#view-report-modal .modal-body', cenrerY: true, animate: true });
                var url = "/dashjs/admin/reportviewer.aspx?docid=" + $('#DocumentSelection').val() + "&uid=" + $('#ClientUsersList').val() + "&dateFrom=" + $('#<%=DateFrom.ClientID%>').val() + "&dateTo=" + $('#<%=DateTo.ClientID%>').val();
                iframe.prop('src', url).css('height', ($(window).height() - 180) + 'px');

                reportModal.modal('show');

                return false;
            });

            
            $('#GenerateAssignmentStatusReport').on('click', function () {
                //Initialization
                var isSingleUserReport = $("#reportTypeRadioSingleUserReport").is(':checked');
                var reportModal = $("#view-assignment-status-report-modal");
                var blockUITarget = '#view-assignment-status-report-modal .modal-body';
                var reportTemplateAssignmentID = $('#<%=AssignmentStatusReportName.ClientID%>').val();

                //Validations
                if (reportTemplateAssignmentID == '0' || (!isSingleUserReport && $('#AssignmentStatusEmployeesMulti .selected-users').val() == '0') || (isSingleUserReport && $('#AssignmentStatusEmployeesSingle').val() == '0')) {
                    showErrorMsgs($('#AssignmentStatusReport'), ["Please fill in all the fields in order to generate the report"]);
                    return;
                };

                if (isSingleUserReport) {
                    var userId = $('#AssignmentStatusEmployeesSingle').val();
                    var url = "/dashjs/admin/reportviewer.aspx?ReportTemplateAssignmentID=" + reportTemplateAssignmentID + "&uid=" + userId;
                } else {
                    var url = "/dashjs/admin/MultiUserReport.aspx?ReportTemplateAssignmentID=" + reportTemplateAssignmentID;
                }

                reportModal.data('docid', $('#AssignmentStatusReportName').val())
                            .data('documentname', $('#DocumentSelectionMultiUser option:selected').text());

                //Load report
                Metronic.blockUI({ target: blockUITarget, cenrerY: true, animate: true });

                var iframe = reportModal.find('iframe');
                iframe.load(function () {
                    iframe.show();
                    Metronic.unblockUI(blockUITarget);
                });

                iframe.prop('src', url).css('height', ($(window).height() - 180) + 'px');
                iframe.hide();

                reportModal.modal('show');

                return false;
            });

            reportModal.find('#save-and-download, #save').on('click', function () {
                var downloadFile = $(this).prop('id') == 'save-and-download';

                callWebService({
                    url: "/ManageUpWebService.asmx/GenerateReportPDF",
                    data: JSON.stringify({
                        docID: reportModal.data('docid'),
                        belongsTo: reportModal.data('belongsto'),
                        dateFrom: reportModal.data('datefrom'),
                        dateTo: reportModal.data('dateto'),
                        documentName: reportModal.data('documentname'),
                        promotion: reportModal.find('iframe').contents().find('#chkPromotion').is(':checked'),
                        demotion: reportModal.find('iframe').contents().find("#chkDemotion").is(':checked'),
                        maintained: reportModal.find('iframe').contents().find("#chkMaintained").is(':checked')
                    }),
                    success: function (data) {
                        reportModal.modal('hide');
                        if (downloadFile) {
                            documentToDownloadURL = data.d;
                        };
                    },
                    blockTarget: reportModal.find('.modal-body')
                });

                return false;
            });

            $('#view-multi-report-modal').find('#save-and-download-multi, #save-multi').on('click', function () {
                var downloadFile = $(this).prop('id') == 'save-and-download-multi';
                var multiUserModal = $('#view-multi-report-modal');

                var openedNodes = '';
                $.each(multiUserModal.find('iframe').contents().find('.portlet-body:visible'), function (i, el) {
                    openedNodes += $(el).data('id') + ' ';
                });

                callWebService({
                    url: "/ManageUpWebService.asmx/GenerateMultiReportPDF",
                    data: JSON.stringify({
                        reportID: multiUserModal.data('docid'),
                        selectedUsers: $('#<%=ClientUserListMultiple.ClientID%> .selected-users').val(),
                        dateFrom: multiUserModal.data('datefrom'),
                        dateTo: multiUserModal.data('dateto'),
                        documentName: multiUserModal.data('documentname'),
                        openedNodes: openedNodes
                    }),
                    success: function (data) {
                        multiUserModal.modal('hide');
                        if (downloadFile) {
                            documentToDownloadURL = data.d;
                        };
                    },
                    blockTarget: multiUserModal.find('.modal-body')
                });

                return false;
            });

            reportModal.on('hide.bs.modal', function () {
                reloadDocuments();
            });

            $('#view-multi-report-modal').on('hide.bs.modal', function () {
                reloadDocuments();
            });

            $('body').on('click', 'a.archive-or-unarchive', function () {
                var reportID = $(this).data('reportid');

                callWebService({
                    data: JSON.stringify({ reportID: reportID }),
                    url: "/ManageUpWebService.asmx/ArchiveOrUnarchiveReportDocLog",
                    success: function (data) {
                        reloadDocuments();
                    },
                    blockTarget: $('#doc-list-container')
                });

                return false;
            });

            $('body').on('click', 'a.archive-or-unarchive-multi', function () {
                var reportID = $(this).data('reportid');

                callWebService({
                    data: JSON.stringify({ reportID: reportID }),
                    url: "/ManageUpWebService.asmx/ArchiveOrUnarchiveMultiReport",
                    success: function (data) {
                        reloadDocuments();
                    },
                    blockTarget: $('#multi-report-list-container')
                });

                return false;
            });

            $('#show-archived-reports, #show-archived-multi-report').on('change', function () {
                reloadDocuments();
            });

            $('input[name=reportTypeRadio]').on('change', function () {
                toggleAssignmentStatusEmployeesContainers();
            });

            $('#<%=AssignmentStatusReportName.ClientID%>').on('change', function () {
                loadAssignmentStatusUsers();
            });


            $('body').on('click', 'a.refresh-report', function () {
                var reportID = $(this).data('reportid');
                var belongsTo = $(this).data('belongsTo');
                var dateFrom = $(this).data('dateFrom');
                var dateTo = $(this).data('dateTo');
                
                $('#<%=DocumentSelection.ClientID%>').val(reportID).trigger("change");
                $('#ClientUsersList').val(belongsTo).trigger("change");
                $('#<%=DateFrom.ClientID%>').val(dateFrom);
                $('#<%=DateTo.ClientID%>').val(dateTo);

                $('#GenerateDocument').trigger('click');

                return false;
            });
            
            $('body').on('click', 'a.refresh-report-multi', function () {
                var reportID = $(this).data('reportid');
                var users = $(this).data('users');
                var dateFrom = $(this).data('dateFrom');
                var dateTo = $(this).data('dateTo');
                
                $('#<%=DocumentSelectionMultiUser.ClientID%>').val(reportID).trigger("change");
                $('#<%=ClientUserListMultiple.ClientID%>').find('.selected-users').val(users).trigger('change');
                $('#<%=DateFromMulti.ClientID%>').val(dateFrom);
                $('#<%=DateToMulti.ClientID%>').val(dateTo);

                $('#GenerateMultiUserReport').trigger('click');

                return false;
            });

            

            <%if (Request.QueryString["DocID"] != null)
            {%>
                $('#GenerateDocument').trigger('click');
            <%}%>
        });

        var toggleAssignmentStatusEmployeesContainers = function()
        {
            var radioValue = $('input[name=reportTypeRadio]:checked').val();

            if (radioValue == 'single-user') {
                $("#AssignmentStatusEmployeesSingleContainer").show();
                $("#AssignmentStatusEmployeesMultiContainer").hide();
            } else {
                $("#AssignmentStatusEmployeesSingleContainer").hide();
                $("#AssignmentStatusEmployeesMultiContainer").show();
            }
        }

        var loadAssignmentStatusUsers = function (callback) {
            var assignmentStatusEmployeesSingle = $("#AssignmentStatusEmployeesSingle");
            var assignmentStatusEmployeesMulti = $("#<%=AssignmentStatusEmployeesMulti.ClientID%>");

            assignmentStatusEmployeesSingle.empty();
            assignmentStatusEmployeesSingle.append($('<option>', {
                value: '0',
                text: 'Select'
            }));
            assignmentStatusEmployeesSingle.val("0").trigger("change");

            callWebService({
                url: "mydocs.aspx/GetReportTemplateAssignmentUsers",
                data: JSON.stringify({ reportTemplateAssignmentID : $('#<%=AssignmentStatusReportName.ClientID%>').val()}),
                success: function (users) {
                    assignmentStatusEmployeesSingle.empty();

                    users = users.d;
                    $.each(users, function (index, user) {
                        assignmentStatusEmployeesSingle.append($('<option>', {
                            value: user.UserID,
                            text: user.FullName
                        }));
                    });

                    assignmentStatusEmployeesSingle.trigger("change");

                    var userIds = $.map(users, function (v) {
                        return v.UserID;
                    });

                    assignmentStatusEmployeesMulti.find('.selected-users').val(userIds.join()).trigger('change');

                    if (callback)
                        callback();
                },
                blockTarget: $("#AssignmentStatusReport")
            });
        }

        var reloadDocuments = function () {
            var semaphore = 0;

            callWebService({
                url: "mydocs.aspx/GetDocuments",
                data: JSON.stringify({ includeArchived: $('#show-archived-reports').is(':checked') }),
                success: function (data) {
                    $('#doc-list-container').html(data.d);
                    $('#doc-list-container table').dataTable({ stateSave: true });

                    downloadFile(++semaphore);
                },
                blockTarget: $('#doc-list-container')
            });

            callWebService({
                url: "mydocs.aspx/GetMultiUserReport",
                data: JSON.stringify({ includeArchived: $('#show-archived-multi-report').is(':checked') }),
                success: function (data) {
                    $('#multi-report-list-container').html(data.d);
                    $('#multi-report-list-container table').dataTable({ stateSave: true });

                    downloadFile(++semaphore);
                },
                blockTarget: $('#multi-report-list-container')
            });
        };

        var downloadFile = function (semaphore) {
            if (documentToDownloadURL && semaphore == 2) {
                window.location.assign(documentToDownloadURL);
                documentToDownloadURL = '';
            }
        }
    </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row">
                <div id="success-msg" class="alert alert-success span12" style="display: none;">
                </div>
            </div>


            <div class="row margin-top-15">
                <div class="col-md-12">
                    <div class="portlet box green" data-team="false">
                        <div class="portlet-title" style="border: none;">
                            <div class="caption">
                                GENERATE REPORTS
                            </div>

                            <ul class="nav nav-tabs">
                                <li id="SingleUserReportTab" class="active">
                                    <a href="#SingleUserReport" data-toggle="tab">
                                        <i class="fa fa-user withTooltip" style="font-size: 25px; padding-top: 6px;" data-title="Single User Report"></i>
                                    </a>
                                </li>

                                <li id="MultiUserReportTab" runat="server">
                                    <a href="#<%=MultiUserReport.ClientID %>" data-toggle="tab">
                                        <i class="icon icon-stackoverflow withTooltip" style="font-size: 25px;" data-title="High level activity view"></i>
                                    </a>
                                </li>
                                
                                <li id="AssignmentStatusReportTab" runat="server">
                                    <a href="#AssignmentStatusReport" data-toggle="tab">
                                        <i class="fa fa-bar-chart withTooltip" style="font-size: 25px; padding-top: 6px;" data-title="Report assignment status"></i>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <div class="portlet-body" style="position: relative;">
                            <div class="tab-content">
                                <div class="tab-pane active" id="SingleUserReport">
                                    <div class="row top-padding no-bottom">
                                        <div class="col-md-2">
                                            <p class="pull-right report-name">Name of Report</p>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="top-padding">
                                                <div class="form-group no-bottom">
                                                    <asp:DropDownList ID="DocumentSelection" runat="server" AppendDataBoundItems="true" CssClass="form-control" ClientIDMode="Static">
                                                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row no-bottom">
                                        <div class="col-md-2">
                                            <p class="pull-right report-name">Name of Employee</p>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="top-padding">
                                                <div class="form-group no-bottom">
                                                    <asp:DropDownList ID="ClientUsersList" runat="server" AppendDataBoundItems="true" CssClass="form-control" ClientIDMode="Static">
                                                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="top-padding">
                                            <div class="col-md-2">
                                                <p class="pull-right report-name">Date Range</p>
                                            </div>
                                            <div class="col-md-5">
                                                <div class="top-padding">
                                                    <div class="input-group input-large date-picker input-daterange form-group" data-date="" data-date-format="mm/dd/yyyy">
                                                        <input type="text" class="form-control" name="from" id="DateFrom" runat="server" />
                                                        <span class="input-group-addon">to </span>
                                                        <input type="text" class="form-control" name="to" id="DateTo" runat="server" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-2">
                                            <div class="form-group">
                                                <a href="#" class="btn green" id="GenerateDocument">Generate Report</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row playbook">
                                        <div class="col-md-12">
                                            <div class="portlet box">
                                                <div class="portlet-body">
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
                                                        <div class="col-md-12" id="doc-list-container">
                                                            <asp:Literal ID="DocList" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="MultiUserReport" runat="server">
                                    <div class="row top-padding no-bottom">
                                        <div class="col-md-2">
                                            <p class="pull-right report-name">Name of Report</p>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="top-padding">
                                                <div class="form-group no-bottom">
                                                    <asp:DropDownList ID="DocumentSelectionMultiUser" runat="server" AppendDataBoundItems="true" CssClass="form-control" ClientIDMode="Static">
                                                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row no-bottom">
                                        <div class="col-md-2">
                                            <p class="pull-right report-name">Employees</p>
                                        </div>
                                        <div class="col-md-9">
                                            <div class="top-padding">
                                                <div class="form-group no-bottom">
                                                    <uc:UsersGroup runat="server" ID="ClientUserListMultiple"></uc:UsersGroup>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="top-padding">
                                            <div class="col-md-2">
                                                <p class="pull-right report-name">Date Range</p>
                                            </div>
                                            <div class="col-md-10">
                                                <div class="top-padding">
                                                    <div class="form-group">
                                                        <div class="input-group input-large date-picker input-daterange form-group no-margin" data-date="" data-date-format="mm/dd/yyyy">
                                                            <input type="text" class="form-control" name="from" id="DateFromMulti" runat="server" />
                                                            <span class="input-group-addon">to </span>
                                                            <input type="text" class="form-control" name="to" id="DateToMulti" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-2">
                                            <div class="form-group">
                                                <a href="#" class="btn green" id="GenerateMultiUserReport">Generate Report</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row playbook">
                                        <div class="col-md-12">
                                            <div class="portlet box">
                                                <div class="portlet-body">
                                                    <div class="row margin-bottom-15">
                                                        <div class="col-md-12">
                                                            <div class="md-checkbox-list">
                                                                <div class="md-checkbox">
                                                                    <input type="checkbox" id="show-archived-multi-report" class="md-check" />
                                                                    <label for="show-archived-multi-report">
                                                                        <span class="check"></span>
                                                                        <span class="box"></span>
                                                                        Show Archived Reports
                                                                    </label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-12" id="multi-report-list-container">
                                                            <asp:Literal ID="MultiReportContainer" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="AssignmentStatusReport">
                                    <div class="row top-padding no-bottom">
                                        <div class="col-md-2">
                                            <p class="pull-right report-name">Report Assignment Name</p>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="top-padding">
                                                <div class="form-group no-bottom">
                                                    <asp:DropDownList ID="AssignmentStatusReportName" runat="server" AppendDataBoundItems="true" CssClass="form-control" ClientIDMode="Static">
                                                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row no-bottom">
                                        <div class="form-group">
                                            <div class="col-md-2">
                                                <p class="pull-right report-name">Report Type</p>
                                            </div>
                                            <div class="col-md-5">
                                                <div class="radio-list top-padding">
                                                    <label class="radio-inline">
                                                        <input type="radio" name="reportTypeRadio" id="reportTypeRadioSingleUserReport" value="single-user" class="assignment-status-admin-control" /> Single User Report </label>
                                                    <label class="radio-inline">
                                                        <input type="radio" name="reportTypeRadio" id="reportTypeRadioMultiUserReport" value="multi-user" class="assignment-status-admin-control" /> Multi User Report </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" id="AssignmentStatusEmployeesSingleContainer">
                                        <div class="col-md-2">
                                            <p class="pull-right report-name">Name of Employee</p>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="top-padding">
                                                <div class="form-group no-bottom">
                                                    <select id="AssignmentStatusEmployeesSingle" class="form-control assignment-status-admin-control">
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row no-bottom" id="AssignmentStatusEmployeesMultiContainer" style="display:none">
                                        <div class="col-md-2">
                                            <p class="pull-right report-name">Employees</p>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="top-padding">
                                                <div class="form-group no-bottom">
                                                    <uc:UsersGroup runat="server" ID="AssignmentStatusEmployeesMulti"></uc:UsersGroup>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5 col-md-offset-2">
                                            <div class="form-group">
                                                <a href="#" class="btn green" id="GenerateAssignmentStatusReport">Generate Report</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ContentPlaceHolderID="modals" runat="server">
    <uc:UsersGroupModal runat="server" ID="UsersGroupModal" />
    <div id="view-report-modal" class="modal fade bs-modal-lg" aria-hidden="true">
        <div class="modal-dialog modal-full">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                </div>
                <div class="modal-body text-center">
                    <iframe src="" style="display: none;" frameborder="0" width="99%"></iframe>
                </div>
                <div class="modal-footer">
                    <button id="save-and-download" class="btn green" aria-hidden="true">Save and Download</button>
                    <button id="save" class="btn green" aria-hidden="true">Save</button>
                    <button class="btn red" data-dismiss="modal" aria-hidden="true">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div id="view-multi-report-modal" class="modal fade bs-modal-lg" aria-hidden="true">
        <div class="modal-dialog modal-full">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                </div>
                <div class="modal-body text-center">
                    <iframe src="" style="display: none;" frameborder="0" width="99%"></iframe>
                </div>
                <div class="modal-footer">
                    <button id="save-and-download-multi" class="btn green" aria-hidden="true">Save and Download</button>
                    <button id="save-multi" class="btn green" aria-hidden="true">Save</button>
                    <button class="btn red" data-dismiss="modal" aria-hidden="true">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div id="view-assignment-status-report-modal" class="modal fade bs-modal-lg" aria-hidden="true">
        <div class="modal-dialog modal-full">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                </div>
                <div class="modal-body text-center">
                    <iframe src="" style="display: none;" frameborder="0" width="99%"></iframe>
                </div>
                <div class="modal-footer">
                    <button class="btn red" data-dismiss="modal" aria-hidden="true">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
