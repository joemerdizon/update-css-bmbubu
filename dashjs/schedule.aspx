<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="schedule.aspx.cs" MasterPageFile="~/MasterNewUI.Master"  Inherits="ManageUPPRM.dashjs.schedule" EnableEventValidation="false" EnableViewStateMac="false" %>
<%@ Import namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="ScheduleForm" Src="~/UserControls/ScheduleForm.ascx" %>
<%@ Register Assembly="DayPilot" Namespace="DayPilot.Web.Ui" TagPrefix="DayPilot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <meta http-equiv="Page-Enter" content="RevealTrans(Duration=0,Transition=0)" />

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>


    <script src="../Scripts/jquery.isloading.js"></script>
    <script src="../Scripts/jquery.tmpl.min.js"></script>
    <script src="../Scripts/moment.js"></script>
    <script src="./js/bootstrap-datepicker.js"></script>
    <script src="./js/bootstrap-timepicker.js"></script>
    <script src="./js/common.js"></script>
    <script src="./js/schedule.js"></script>
    <script src="./js/fuelUx/scheduler.js"></script>
    <script src="./js/dataTables/jquery.dataTables.js"></script>
    <script src="./js/dataTables/dataTables.bootstrap.js"></script>
    <script src="js/lightbox/lightboxbs.js"></script>
    <script src="<%= Page.ContentLastWrite("/dashjs/js/keepAuthenticationAlive.js")%>"></script>

    <link href="../Content/dataTables.bootstrap.css" rel="stylesheet" />
    <link href="../Content/jquery.dataTables.css" rel="stylesheet" />

    <link href="../Content/datetime/datetime.css" rel="stylesheet" />

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png" />

    <script type="text/javascript">
        $(document).ajaxStart(function () {
            $("#LoadingModal").modal('show');
        });

        $(document).ajaxStop(function () {
            $("#LoadingModal").modal('hide');
        });

        function ShowMedia(catid, doclink) {
            switch (parseInt(catid)) {
                case 1:
                    var win = window.open(doclink, '_blank');
                    break;
                case 2:
                    //   ShowVideo(doclink);
                    break;
            }
            return true;
        }

        function ShowResources(id) {
            $.ajax({
                type: "POST",
                url: "./schedule.aspx/GetResourceList",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ ResourceID: id }),
                success: function (data) {
                    $("#ResList").html('');
                    $("#ResList").append(data.d);
                    $("#ResListTable").dataTable();
                    $("#ResourcesModal").modal('show');
                },
            });
        };
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <asp:ScriptManager ID="AdminPageScriptManger" runat="server"></asp:ScriptManager>
        <input type="hidden" id="SelectedDay" runat="server" />
        <input type="hidden" id="UserName" runat="server" />
        <input type="hidden" id="LastDepartmentSelected" runat="server" />
        <input type="hidden" id="SchedulerView" runat="server" />
        <input type="hidden" id="SubmitUserList" runat="server" />


        <div class="page-content-wrapper">
        <div class="page-content">

            <!-- start container -->
            <div class="row">

                <div id="SysMessage" runat="server">
                    <h1>Coming soon</h1>
                </div>
                <div class="" id="ScheduleContainer" runat="server">
                    <h2>Team Schedule</h2>
                    <%--<div class="row-fluid">
                        <div class="span12">
                            <div class="calendar-selection"></div>
                        </div>
                    </div>--%>
                    <br />
                    <div class="row-fluid">
                        <div class="fuelux no-left-margin fontsize">
                            <div class="span4">
                                <div class="control-group">
                                    <label class="control-label" for="DepartmentSelect">Departments</label>
                                    <div class="controls">
                                        <select id="DepartmentSelect" runat="server" onchange="doPostBack()"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="span8" runat="server" id="DepartmentsLocationContainer">
                                <div class="control-group">
                                    <label class="control-label" for="DepartmentSelect">Department locations</label>
                                    <div class="controls">
                                        <select id="DepartmentBranchSelect" runat="server" onchange="doPostBack()"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row-fluid">
                        <div class="span12">
                            <div class="row-fluid">
                                <div class="success-msg alert alert-success span12" style="display: none;">
                                </div>
                            </div>
                            <div class="row-fluid">
                                <div class="span3">
                                    <input class="btn" type="button" value="Callout" id="callout-btn">
                                    <input class="btn create-btn" type="button" value="Create">
                                </div>
                                <div class="span2 text-right">
                                    <input class="btn cal-today" type="button" value="Today">
                                </div>
                                <div class="span2 text-center">
                                    <input class="btn prev cal-prev" type="button" value="«">
                                    <input class="btn calendar-selection input-small" type="button" value="Calendar">
                                    <input class="btn next cal-next" type="button" value="»">
                                </div>
                                <div class="span5 text-right">
                                    <input class="btn scheduler-view" type="button" value="Month">
                                    <input class="btn scheduler-view" type="button" value="Week">
                                    <input class="btn scheduler-view" type="button" value="Day">
                                </div>
                            </div>
                            <div class="row-fluid">
                                <div class="span12">
                                    <DayPilot:DayPilotScheduler ID="DayPilotScheduler" runat="server" OnBeforeCellRender="DayPilotScheduler_BeforeCellRender" OnBeforeEventRender="DayPilotScheduler_BeforeEventRender" OnBeforeResHeaderRender="DayPilotScheduler_BeforeResHeaderRender"
                                        OnIncludeCell="DayPilotScheduler_IncludeCell"
                                        CssOnly="true"
                                        DataStartField="start"
                                        DataEndField="end"
                                        DataTextField="name"
                                        DataValueField="id"
                                        DataResourceField="resource"
                                        CellGroupBy="Month"
                                        CellDuration="1440"
                                        Width="100%"
                                        EventHeight="25"
                                        HeaderFontSize="8pt"
                                        EventFontSize="8pt"
                                        CssClassPrefix="scheduler_green"
                                        EventClickHandling="JavaScript"
                                        TreeEnabled="true"
                                        TreeImageNoChildren="false"
                                        EventClickJavaScript="eventClick(e);">
                                    </DayPilot:DayPilotScheduler>
                                </div>
                                <div style="display: none;">
                                    <asp:Literal ID="scheduleItemsContainer" runat="server">
                                    </asp:Literal>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="sidebar span3">
                </div>
            </div>
        </div></div>

        <div id="create-modal" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h2>Create new schedule item</h2>
                    </div>
                    <div class="modal-body">
                        <uc:ScheduleForm runat="server" ID="CreateScheduleForm"></uc:ScheduleForm>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-success submit-event" value="Save" />
                        <a href="#" class="btn btn-danger" data-dismiss="modal" onclick="resetForm()">Cancel</a>
                    </div>
                </div>
            </div>
        </div>
        <div id="edit-modal" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
 
                    <div class="modal-header">
                        <h2>Edit schedule item:</h2>
                    </div>
                    <div class="modal-body">
                        <uc:ScheduleForm runat="server" ID="EditScheduleForm"></uc:ScheduleForm>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-success submit-event" value="Save" />
                        <a href="#" class="btn btn-danger" data-dismiss="modal" onclick="resetForm()">Cancel</a>
                    </div>
                </div>
            </div>
        </div>
        <div id="edit-resource-status"  class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h2>Resource: <span class="resource-name"></span></h2>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal fuelux no-left-margin" role="form">
                            <div class="error-msg alert alert-error" style="display: none;">
                            </div>
                            <input type="hidden" class="resource-id" value="" />
                            <div class="control-group">
                                <label for="name" class="control-label">Current status</label>
                                <div class="controls controls-row">
                                    <span class="current-status"><span class="circle">● </span><span class="content"></span></span>
                                </div>
                            </div>

                            <div class="control-group">
                                <label for="status" class="control-label">Change status</label>
                                <div class="controls controls-row">
                                    <select class="available-status span5" name="status"></select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-success submit-resource-status" value="Save" />
                        <a href="#" class="btn btn-danger" data-dismiss="modal" onclick="resetForm()">Cancel</a>
                    </div>
                </div>
            </div>
        </div>
        <div id="callout-modal"  class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h2>Callout</h2>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal fuelux no-left-margin" role="form">
                            <div class="alert alert-error" style="display: none;">
                            </div>

                            <div class="control-group">
                                <label for="name" class="control-label">Reason</label>
                                <div class="controls controls-row">
                                    <select id="ActionReason" runat="server"></select>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Start</label>
                                <div class="controls controls-row">
                                    <div class="input-append span2 no-left-margin">
                                        <input type="text" name="startDate" class="startDate-input with-datepicker form-control input-small" />
                                        <button type="button" class="btn show-calendar"><i class="icon-calendar"></i></button>
                                    </div>
                                    <div class="span2 input-append bootstrap-timepicker">
                                        <input type="text" name="startTime" class="startTime-input input-small" />
                                        <span class="add-on"><i class="icon-time"></i></span>
                                    </div>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="endDate" class="control-label">End</label>
                                <div class="controls controls-row">
                                    <div class="input-append span2 no-left-margin">
                                        <input type="text" name="endDate" class="endDate-input with-datepicker form-control input-small" />
                                        <button type="button" class="btn show-calendar"><i class="icon-calendar"></i></button>
                                    </div>
                                    <div class="span2 input-append bootstrap-timepicker">
                                        <input type="text" name="endTime" class="endTime-input input-small" />
                                        <span class="add-on"><i class="icon-time"></i></span>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" class="username-val" name="username" value="" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-success save-callout" value="Save" />
                        <a href="#" class="btn btn-danger" data-dismiss="modal" onclick="resetForm()">Cancel</a>
                    </div>
                </div>
            </div>
        </div>
        <div id="schudule-item-actions" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2></h2>
                    </div>
                    <div class="modal-body">
                        <a href="javascript:void(0)" class="btn" data-dismiss="modal" id="edit-schedule-item">Edit Schedule</a>
                        <a href="javascript:void(0)" class="btn" data-dismiss="modal" id="show-schedule-item-users">Show Preference</a>
                    </div>
                    <div class="modal-footer">
                        <a href="javascript:void(0)" class="btn btn-danger" data-dismiss="modal">Close</a>
                    </div>
                </div>
            </div>
        </div>
        <div id="show-user-preferences" class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h2></h2>
                    </div>
                    <div class="modal-body">
                        <div class="tabs-container">
                            <ul class="nav nav-tabs">
                                <li class="active"><a id="main-user" href="#main-user-pane" data-toggle="tab">Main user</a></li>
                                <li><a id="cover-user" href="#cover-user-pane" data-toggle="tab">Cover user</a></li>
                            </ul>
                            <div class="tab-content">
                                <div class="tab-pane active" id='main-user-pane'></div>
                                <div class="tab-pane" id='cover-user-pane'></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn btn-danger" data-dismiss="modal">Close</a>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" runat="server" id="showSuccessMsg" />


        <div id="ResourcesModal"  class="modal fade"  tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h2>Resources</h2>
                    </div>
                    <div class="modal-body">
                        <div id="ResList" />
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-success" data-dismiss="modal" aria-hidden="true">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="LoadingModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="windowTitleLabel" aria-hidden="true">
            <div class="modal-header">
                <h3>Working...&nbsp<img src="./img/ajax-loader.gif" /></h3>
            </div>
            <div class="modal-footer">
            </div>
        </div>

</asp:Content>