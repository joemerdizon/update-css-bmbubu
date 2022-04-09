<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="dashboardjsNew.aspx.cs" Inherits="ManageUPPRM.dashjs.dashboardjsNew" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="CalendarEventForm" Src="~/UserControls/CalendarEventForm.ascx" %>
<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="" />
    <meta name="author" content="" />

    <script src="js/jquery.timer.js"></script>
    <script src="/Scripts/jquery.cookie.js"></script>

    <script type="text/javascript">
        var ShowAllTasks;
    </script>

    <script type="text/javascript">
        var chart;
        window.actionID = "1";
        var showAllTasks = false;


        $(document).ready(function () {
            if ($.cookie('showAllTasks')) {
                showAllTasks = $.cookie('showAllTasks');

                if (showAllTasks == "true") {
                    $(".team-toggle").addClass("active");
                    $(".my-toggle").removeClass("active");
                }
            };

            //UpdateChart();
            loadingChart();
            GetChart(false);
            $('.my-team-switch input.toggle').on('change', function (event) {
                var myTasks = $(this).val() == "my";
                showAllTasks = !myTasks;
                $.cookie('showAllTasks', showAllTasks);
                loadingChart();
                GetChart(false);

                if (myTasks) {
                    // my tasks
                    $('.nav-tabs a[href="#tasks_tab_1"]').tab('show');

                } else {

                    // team tasks
                    $('.nav-tabs a[href="#tasks_tab_2"]').tab('show');
                }
            });

            //Set last 
            if ($.cookie('selected-tab-dashboard')) {
                $('#task-tabs a[href="' + $.cookie('selected-tab-dashboard') + '"]').tab('show');
            };

            $('#task-tabs li').on('shown.bs.tab', function (e) {
                $.cookie('selected-tab-dashboard', $(e.target).attr('href'));
            })
        });

        function loadingChart() {
            Metronic.blockUI({ target: '#objectives-container', cenrerY: true, animate: true });
        };

        function GetChart(showMessage) {
            var DTO = { 'ShowAllTasks': showAllTasks };
            $.ajax({
                type: "POST",
                url: "../ManageUPWebService.asmx/GetTaskAggregateNew",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (chartdata) {
                    data = chartdata.d;
                   
                    completed = data.CompletedTasks;
                    pending = data.DueSoonTasks;
                    immediate = data.UrgentTasks;
                    newitems = data.NewTasks;

                    if (completed === 0 && pending === 0 && immediate === 0 && newitems === 0) {
                        $("#info-msg-chart").html('<p>No data</p>').closest('.row').show();
                        $('div.my_tasks').hide();
                        Metronic.unblockUI('#objectives-container');
                    }
                    else {
                        $("#info-msg-chart").closest('.row').hide();
                        $('div.my_tasks').show();
                        data = new Array();
                        data[0] = completed;
                        data[1] = pending;
                        data[2] = immediate;
                        data[3] = newitems;
                        drawChart(data);
                        //if (showMessage == true) {
                        //  $("TransparencyChartUpdate").modal('show');
                        //}
                    }
                }
            });
        }
    </script>

    <script type="text/javascript">

        var lastClickGraph;

        function drawChart(thisdata) {
            lastData = thisdata;
            var data = [
                { label: "Completed", data: thisdata[0], color: "#4CA249" }, //1E5108
                { label: "Due Soon", data: thisdata[1], color: "#FED500" }, //F2C403
                { label: "Urgent", data: thisdata[2], color: "#BF353C" }, //821B1B
                { label: "New", data: thisdata[3], color: "#FE8A00" }]; //E07117


            var data2 = google.visualization.arrayToDataTable([
              ['Task', 'Count'],
              ['Completed', thisdata[0]],
              ['Due Soon', thisdata[1]],
              ['Urgent', thisdata[2]],
              ['New', thisdata[3]]
            ]);

            var options = {
                title: '',
                pieSliceText: 'none',
                is3D: true,
                legend: { position: 'labeled' },
                chartArea: { left: 20, top: 0, width: '100%', height: '100%' },
                colors: ['#4CA249', '#FED500', '#BF353C', '#FE8A00']
            };

            var chart = new google.visualization.PieChart(document.getElementById('piechart'));

            chart.draw(data2, options);


            //var colors = ['#4CA249', '#FED500', '#BF353C', '#FE8A00'];
            //var colors = ['#4CA249', '#BF353C', '#FE8A00','#FED500'];

            //var chartId = 'piechart';
            //var dataLength = 2;
            //var graphics = document.getElementById(chartId).querySelectorAll("svg > g");
            // graphics[0] is title, graphics[1..n] are pie slices, and we take label area which is graphics[n+1]
            //var labelsGraphics = graphics[dataLength+1].childNodes; 


            // get svg graphics and replace colors
            //var replaceLabelColors = function(){
            //  var colorIndex = 0;
            //for (var i = 0; i < labelsGraphics.length; i++) {
            //                    if (i % 2 == 0) {
            // skip even indexes
            //                      continue;
            //                } else {
            //                  var currentLine = labelsGraphics[i];
            //                currentLine.childNodes[0].setAttribute("stroke", colors[colorIndex]); // <path stroke="#636363" ...>
            //              currentLine.childNodes[1].setAttribute("fill", colors[colorIndex]); // <circle fill="#636363" ...>
            //            colorIndex++;
            //      }
            //}
            //}

            //replaceLabelColors();
            //google.visualization.events.addListener(chart, "onmouseover", replaceLabelColors);
            //google.visualization.events.addListener(chart, "onmouseout", replaceLabelColors);


            Metronic.unblockUI('#objectives-container');

            //google.visualization.events.addListener(chart, 'select', selectHandler);
            google.visualization.events.addListener(chart, 'select', function () {
                //  try {

                var selectedItem = chart.getSelection()[0];
                var cat = data2.getValue(selectedItem.row, 0);

                window.location.href = '/dashjs/tasks.aspx?team=' + showAllTasks + '&action=' + cat;
            });
        }


    </script>

    <script type="text/javascript">
        var data;
        var newitems // = 4;
        var pending;
        var completed;
        var immediate;

        var lastData;

        $(document).ready(function () {

            //$("#UserList1").multiselect({
            //    enableFiletering: true,
            //});

            //GerMessageCount();

            //$("#AlertTabs a").click(function (e) {
            //    e.preventDefault();
            //    $(this).tab('show');
            //});

            //$("#alternate").change(function () {
            //    alert('tedt');
            //});
        });

        function GerMessageCount() {
            var userid = '<%=GetUserID()%>';
            $.ajax({
                type: "POST",
                url: "../ManageUPWebService.asmx/GetUserMessageCount",
                async: true,
                data: "{userID:'" + userid + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    if (data.d > 0) {
                        $('#chat').removeClass("social-feed-numbers-gray");
                        $('#chat').addClass("social-feed-numbers-red");
                        $('#chat').text(data.d);
                    }
                    else {

                        $('#chat').removeClass("social-feed-numbers-red");
                        $('#chat').addClass("social-feed-numbers-gray");
                        $('#chat').text("");
                    }

                }
            });
        }

        function ShowAllTasksModal() {
            $("#ResourcesModal").modal('hide');
            $("#AllTaskListModal").modal('show');
            $('ul.nav-tabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {

                $('#AllCompletedTasksLoader').empty();
                $('#AllUrgentTasksLoader').empty();
                $('#AllDueSoonTasksLoader').empty();
                $('#AllTasksLoader').empty();
                $('#AllNewTasks').DataTable();

                var tabType = $(e.target).attr('data-type');

                if (tabType == 'CompletedTasks') {

                    $('#AllCompletedTasksLoader').html('<img src="img/ajax-loader.gif" />');
                    window.actionID = "1";
                    GetAllTasks();
                }
                else if (tabType == 'UrgentTasks') {

                    $('#AllUrgentTasksLoader').append('<img src="img/ajax-loader.gif" />');
                    window.actionID = "2";
                    GetAllTasks();
                }
                else if (tabType == 'DueSoonTasks') {

                    $('#AllDueSoonTasksLoader').append('<img src="img/ajax-loader.gif" />');
                    window.actionID = "3";
                    GetAllTasks();
                }
                else if (tabType == 'NewTasks') {

                    $('#AllNewTasksLoader').append('<img src="img/ajax-loader.gif" />');
                    window.actionID = "4";
                    GetAllTasks();
                }
                else if (tabType == 'AllTasks') {
                    $('#AllTasksLoader').append('<img src="img/ajax-loader.gif" />');
                    window.actionID = "0";
                    GetAllTasks();
                };

            });
            $('#AllTasksTabs a:first').tab('show');
        }

        function ShowTaskList(msg) {

            switch (msg) {
                case 0:
                    $("#welcome_div").empty();
                    break;
                case '':
                    $("#welcome_div").empty();
                    $("#welcome_div").append("<h2>Alerts</h2>");
                    break;
                default:
                    $("#welcome_div").empty();
                    $("#welcome_div").append("<h2>" + msg + "</h2>");
                    break;
            }

            $('#TaskListLoader1').empty();
            $('#TaskListLoader2').empty();
            $('#TaskListLoader3').empty();
            $('#SubmittedForApproval').empty();
            $('#ApprovalRequests').empty();

            $('#TaskListLoader1').append('<img src="img/ajax-loader.gif" />');
            $('#TaskListLoader2').append('<img src="img/ajax-loader.gif" />');
            $('#TaskListLoader3').append('<img src="img/ajax-loader.gif" />');
            $('#SubmittedForApproval').append('<img src="img/ajax-loader.gif" />');
            $('#ApprovalRequests').append('<img src="img/ajax-loader.gif" />');

            $('#TaskListDialog').on('shown', function () {
                $.ajax({
                    type: "POST",
                    url: "dashboardjsNew.aspx/GetTaskTable",
                    async: true,
                    data: "{Action:'" + 1 + "',Category:'" + 5 + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        $('#TaskListLoader1').empty();
                        if (data.d.length === 0) {
                        }
                        else {
                            $('#TaskListLoader1').append('<h3>My Urgent Tasks</h3>');
                            $('#TaskListLoader1').append(data.d);

                            $('#TaskListLoader1 tbody tr').each(function (i, el) {
                                applyTooltipIfTextIsTooLong($(el).find('td:nth-child(2)'), 20, '#TaskListDialog');
                            });

                            $('#UrgentTaskList').dataTable();
                        }
                    }
                });

                $.ajax({
                    type: "POST",
                    url: "dashboardjsNew.aspx/GetTaskTable",
                    async: true,
                    data: "{Action:'" + 2 + "',Category:'" + 5 + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        if (data.d.length == 0) {
                            $('#TaskListLoader2').empty();
                        }
                        else {
                            $('#TaskListLoader2').empty();
                            $('#TaskListLoader2').html('<h3>Team Tasks</h3>');
                            $('#TaskListLoader2').append(data.d);

                            $('#TaskListLoader2 tbody tr').each(function (i, el) {
                                applyTooltipIfTextIsTooLong($(el).find('td:nth-child(2)'), 20, '#TaskListDialog');
                            });

                            $('#TeamUrgentTaskList').dataTable();
                        }
                    }
                });

                $.ajax({
                    type: "POST",
                    url: "dashboardjsNew.aspx/GetTaskTable",
                    async: true,
                    data: "{Action:'" + 3 + "',Category:'" + 5 + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        if (data.d.length == 0) {
                            $('#TaskListLoader3').empty();
                        }
                        else {
                            $('#TaskListLoader3').empty();
                            $('#TaskListLoader3').html('<h3>Covered Tasks</h3>');
                            $('#TaskListLoader3').append(data.d);

                            $('#TaskListLoader3 tbody tr').each(function (i, el) {
                                applyTooltipIfTextIsTooLong($(el).find('td:nth-child(2)'), 20, '#TaskListDialog');
                            });

                            $('#CoveredTeamTaskList').dataTable();
                        }
                    }
                });

                $.ajax({
                    type: "POST",
                    url: "dashboardjsNew.aspx/GetTaskTable",
                    async: true,
                    data: "{Action:'" + 6 + "',Category:'" + 6 + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        var tableContainer = $('#SubmittedForApproval');

                        if (data.d.length == 0) {
                            tableContainer.empty();
                        }
                        else {
                            tableContainer.empty();
                            tableContainer.html('<h3>Submitted for approval</h3>');
                            tableContainer.append(data.d);

                            tableContainer.find('tbody tr').each(function (i, el) {
                                applyTooltipIfTextIsTooLong($(el).find('td:nth-child(2)'), 20, '#TaskListDialog');
                            });

                            tableContainer.find('table').dataTable();
                        }
                    }
                });

                $.ajax({
                    type: "POST",
                    url: "dashboardjsNew.aspx/GetTaskTable",
                    async: true,
                    data: "{Action:'" + 7 + "',Category:'" + 7 + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        var tableContainer = $('#ApprovalRequests');

                        if (data.d.length == 0) {
                            tableContainer.empty();
                        }
                        else {
                            tableContainer.empty();
                            tableContainer.html('<h3>Approval Requests</h3>');
                            tableContainer.append(data.d);

                            tableContainer.find('tbody tr').each(function (i, el) {
                                applyTooltipIfTextIsTooLong($(el).find('td:nth-child(2)'), 20, '#TaskListDialog');
                            });

                            tableContainer.find('table').dataTable();
                        }
                    }
                });
            });

            $('#TaskListDialog').modal({
                backdrop: true,
                keyboard: true,
                show: false
            }).css({
                // make width 90% of screen
                'width': function () {
                    return ($(document).width() * .5) + 'px';
                },
                // center model
                'margin-left': function () {
                    return -($(this).width() / 2);
                }
            });

            if (msg === 0) {
                $("#AlertTab1").removeClass("active");
                $("#tab1").removeClass("active");
                $("#AlertTab2").addClass("active");
                $("#tab2").addClass("active");
            }

            $('#TaskListDialog').modal('show');
        }

        function CloseTaskList() {
            $('#TaskListDialog').modal('hide');
        }

        function ShowResources() {
            $("#ResourcesModal").modal('show');
        }

        function RedirectToMyProfile() {
            $("#HelpModal").modal('hide');
            var url = "./admin/profile.aspx";
            $(location).attr('href', url);
        }

        function ShowHelpModal() {
            $("#HelpModal").modal('show');
        }

        function ShowLeaderBoardModal() {
            $.ajax({
                type: "POST",
                url: "dashboardjsNew.aspx/GetLeaderboard",
                async: true,
                beforeSend: function () {
                    $("#ResourcesModal").modal('hide');
                    $("#LeaderboardModal").modal('show');
                },
                data: {},
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("#LeaderboardDiv").html('');
                    $("#LeaderboardDiv").html(data.d);
                },
            });
        }

        function ShowGenericModal() {
            $("#ResourcesModal").modal('hide');
            $("#GenericComingSoon").modal('show');
        }

        function RedirectToMyDocs() {
            $("#ResourcesModal").modal('hide');
            var url = "./admin/mydocs.aspx";
            $(location).attr('href', url);
        }

        function ShowMessageModal() {
            $("#MessageModal").modal('show');
        }

        function ShowTasks(fordate) {
            $('#TaskModal').modal({
                backdrop: true,
                keyboard: true,
                show: false
            }).css({
                // make width 90% of screen
                'width': function () {
                    return ($(document).width() * .5) + 'px';
                },
                // center model
                'margin-left': function () {
                    return -($(this).width() / 2);
                }
            });
            LoadCalendar();
            $("#AppointmentModal").modal('show');
        }

        $(window).resize(function () {
            if (typeof lastData != 'undefined') {
                drawChart(lastData);
            };
        });

        function GenericComingSoon() {
            $("#GenericComingSoon").modal('show');
        }

        function DismissGenericComingSoon() {
            $("#GenericComingSoon").modal('hide');
        }

        function ShowDynamicDoc(id) {

            $('#DynamicDocModal').modal({
                backdrop: true,
                keyboard: true,
                show: false
            }).css({
                // make width 90% of screen
                'width': function () {
                    return ($(document).width() * .5) + 'px';
                },
                // center model
                'margin-left': function () {
                    return -($(this).width() / 2);
                }
            });

            $('#DynamicDocModalReply').modal({
                backdrop: true,
                keyboard: true,
                show: false
            }).css({
                // make width 90% of screen
                'width': function () {
                    return ($(document).width() * .5) + 'px';
                },
                // center model
                'margin-left': function () {
                    return -($(this).width() / 2);
                }
            });

            $("#DDSubmissionModal").modal('hide');

            if (id == 1) {
                $("#DynamicDocModal").modal('show');
            }
            else {
                $("#DynamicDocModalReply").modal('show');
            }
        }

        function ShowCreateTask() {
            $("#CreateTask").modal('show');
        }

        function AddTaskRedirect(id) {
            $("#CreateTask").modal('hide');
            switch (id) {
                case 1:
                    window.location.href = "addptask.aspx";
                    break;
                case 2:
                    window.location.href = "addtask.aspx";
                    break;
                case 3:
                    window.location.href = "adddtask.aspx";
                    break;
            }
        }

        function RedirectTaskDetail(taskid) {
            if (taskid != "") {
                window.location.href('../dashjs/taskcontroller.aspx?TaskID=' + taskid);
                return false;
            }
        }

        function RedirectDynamicDocument() {
            window.location.href('../dashjs/dynamicdocument.aspx');
            return false;
        }

        function ShowTransparencyUpdate() {
            $("#TransparencyChartUpdate").modal('show');
        }

        function SubmitDD() {
            $("#DDSubmissionModal").modal('show');
        }
    </script>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart"] });
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".nav-tabs li").on('shown.bs.tab', function () {
                var container = $('#task-tabs-content .tab-pane.active');
                getTasksForDashboardjs(container, $(this).data('action'), $(this).data('team'));
            });

            $('li.active').trigger('shown.bs.tab');

            <% if (Request.QueryString["showTrainingModal"].HasValue())
            {%>
                $("#training-modal").modal({ backdrop: 'static' });
            <%}%>
        });

        function getTasksForDashboardjs(container, actionID, team) {
            $.ajax({
                type: "POST",
                url: "../ManageUpWebService.asmx/GetTasksRows",
                async: true,
                data: JSON.stringify({ category: actionID, team: team, linkToChart: true, audit: false }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                    container.find('.dataTables_wrapper').hide();
                    Metronic.blockUI({ target: container, cenrerY: true, animate: true });
                },
                success: function (data) {
                    Metronic.unblockUI(container);
                    container.find('.dataTables_wrapper').show();
                    if (data.d.length == 0) {
                        container.html('<h3>There are no tasks</h3>');
                    }
                    else {
                        var table = container.find('table');
                        if (table.hasClass('dataTable')) {
                            var oTable = table.DataTable();
                            oTable.destroy();
                        };

                        table.find('tbody').html(data.d);

                        if ((actionID != '<%=ManageUPPRM.Catalogs.TaskCategory.Urgent %>' && actionID != '<%=ManageUPPRM.Catalogs.TaskCategory.All %>') || !team) {
                            table.find('tbody tr td.owner-column').remove();
                        };
                        table.find('tbody tr td.not-dashboard-col').remove();

                        table.find('tbody .tooltips').tooltip();
                        table.DataTable({ stateSave: true });
                    };
                }
            });
        };
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>
        * {box-sizing: border-box;}
        ul {list-style-type: none;}
        body {font-family: Verdana, sans-serif;}

        .month {
          padding: 70px 25px;
          width: 100%;
          background: #1abc9c;
          text-align: center;
        }

        .month ul {
          margin: 0;
          padding: 0;
        }

        .month ul li {
          color: white;
          font-size: 20px;
          text-transform: uppercase;
          letter-spacing: 3px;
        }

        .month .prev {
          float: left;
          padding-top: 10px;
        }

        .month .next {
          float: right;
          padding-top: 10px;
        }

        .weekdays {
          margin: 0;
          padding: 10px 0;
          background-color: #ddd;
        }

        .weekdays li {
          display: inline-block;
          width: 13.6%;
          color: #666;
          text-align: center;
        }

        .days {
          padding: 10px 0;
          background: #eee;
          margin: 0;
        }

        .days li {
          list-style-type: none;
          display: inline-block;
          width: 13.6%;
          text-align: center;
          margin-bottom: 5px;
          font-size:12px;
          color: #777;
        }

        .days li .active {
          padding: 5px;
          background: #1abc9c;
          color: white !important
        }

        /* Add media queries for smaller screens */
        @media screen and (max-width:720px) {
          .weekdays li, .days li {width: 13.1%;}
        }

        @media screen and (max-width: 420px) {
          .weekdays li, .days li {width: 12.5%;}
          .days li .active {padding: 2px;}
        }

        @media screen and (max-width: 290px) {
          .weekdays li, .days li {width: 12.2%;}
        }
    </style>

    <div style="display: none">
        <input type="hidden" id="eventCharacterLimit" value="20" />

        <input type="button" class="btn btn-success" value=" Report Documents" onclick="javascript: window.location.href = './admin/ReportDocuments.aspx';" runat="server" id="DocumentReportLink" />
        <img id="LoggedInStatusIcon" runat="server" style="margin-top: 12px; margin-left: auto;" onclick="ShowStatusChangeModal();" />
        <textarea id="MessageBody" cols="100" rows="5" runat="server"></textarea>
        <asp:TextBox runat="server" ID="MessageHeader" />
        <asp:Literal ID="NewsFeedList" runat="server"></asp:Literal>
        <asp:DropDownList ID="UserList" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
        </asp:DropDownList>
        <asp:DropDownList ID="UserStatuses" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
        </asp:DropDownList>
    </div>

    <!--  ///// START CONTENT //////////////////////////////////////// -->
    <div class="page-content-wrapper">
        <div class="page-content">

            <!-- start container -->
            <div class="row">


                <!-- start column 1 -->
                <div class="col-md-6">

                    <!-- start title-->
                    <h3 class="page-title page-title-homepage">Welcome, <%=GetFirstName()%>!</h3>
                    <!-- end title -->


                    <!-- start -->
                    <div class="portlet light bordered" id="objectives-container">

                        <!-- start header -->
                        <div class="portlet-title">
                            <div class="caption">
                                <span class="caption-subject bold uppercase">TASKS</span>
                            </div>
                        </div>
                        <!-- end header -->


                        <!-- start chart -->
                        <div class="portlet-body" style="position: relative;">

                            <div class="btn-group my-team-switch" data-toggle="buttons">
                                <label class="btn btn-default active withTooltip my-toggle" data-original-title="Transparency chart reflects Tasks and Objectives where you are the Assignee (owner)">
                                    <input type="radio" name="myTeam" value="my" class="toggle">
                                    My
                                </label>
                                <label class="btn btn-default withTooltip team-toggle" data-original-title="Transparency chart reflects Tasks and Objectives where you are assigned as a Viewer.  These Tasks and Objectives may belong to users who report to you or members of your project teams and task forces.">
                                    <input type="radio" name="myTeam" value="team" class="toggle">
                                    Team
                                </label>
                            </div>

                            <%--<img id="chartLoading" src="img/ajax-loader.gif" />--%>

                            <!-- DEVELOPER NOTICE: this is your chart -->

                            <!-- Your chart javascript numbers will appear at the bottom -->

                            <div class="row  no-margin" style="display:none;">
                                <div class="alert alert-info top-padding col-md-6">
                                    <strong id="info-msg-chart"></strong>
                                </div>
                            </div>
                            <!--<div id="my_tasks" class="chart" ></div>-->

                            <!--grafico viejo-->
                            <div class="my_tasks" class="chart" style="height: 450px;">
                                <%-- <div id="chart_div" style="z-index: -100;"></div>--%>
                                <div id="piechart" style="height: 70%; width: 100%">
                                </div>

                                <!--
                                    <div id="chart_div" style="width: 700px; height: 500px;" style="display: none">
                                        Loading &nbsp
                                        <img src="img/ajax-loader.gif" />
                                    </div>
                                        -->
                                <!--<input id="ChartSelector" type="checkbox" name="teamchart" value="1" />-->
                                <%--<a href="javascript:ShowAllTasksModal();" class="allTasksLink">All Tasks</a>--%>
                                <div style="clear: both;"></div>
                                <br />
                            </div>



                            <!-- Your chart javascript numbers will appear at the bottom -->


                        </div>
                        <!-- end chart -->

                    </div>
                    <!-- end -->


                </div>
                <!-- end column 1 -->


                <!-- start column 2 -->
                <div class="col-md-6">

                    <!-- start title-->
                    <h3 class="page-title page-title-homepage"></h3>
                    <!-- end title -->

                    <div class="portlet light bordered" style="display: none;">
                        <div class="row homepage-quick-icons">
                            <!-- start email -->
                            <div class="col-md-3 text-center" style="display:none;">
                                <a href="#" runat="server" id="startZoomMeeting"><i class="fa fa-video-camera"></i>Start Meeting</a>
                            </div>
                             <div class="col-md-3 text-center">
                                <a href="/dashjs/TemplateTasks.aspx?assignable=true"><i class="fa fa-cogs"></i>Opportunities</a>
                            </div>
                            <!-- start leaderboard -->
                            <div class="col-md-1 text-center">
                                <a href="/dashjs/leaderboard.aspx"><i class="fa fa-trophy"></i></a>
                            </div>
                            <!-- start website -->
                            <div class="col-md-1 text-center">
                                <a href="#" class="open-new-window" runat="server" id="websiteLink"><i class="fa fa-globe"></i></a>
                            </div>
                            <div class="col-md-3 text-center">
                                <a href="#" class="open-new-window" runat="server" id="customLink" visible="false"><i class="fa fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>


                    <!-- start SQUEEZE -->
                    <%--<div class="portlet light bordered squeeze">
                        <div class="row withTooltip" data-original-title="These reflect SQUEEZE (Safety, Quality, Efficiency, Effectiveness, and Zest) scores you have received.  Points are associated with Objectives you completed and contributions you made. Once the points reach the threshold, it would become a star and the bargraph is reset.">


                            <!-- BACKEND NOTES -->
                            <!-- UPDATE PERCENT AS NEEDED -->

                            <!-- start 1 -->
                            <div class="fifths">
                                <div class="fa fa-star"></div>
                                <span><%=GetScore(1)%></span>
                                <a href="#" class="squeeze-box">
                                    <div class="squeeze-percent" style="width: <%=GetProgressImage(1)%>%;">
                                        <div>S</div>
                                    </div>
                                </a>
                            </div>
                            <!-- end 1 -->
                            <!-- start 2 -->
                            <div class="fifths">
                                <div class="fa fa-star"></div>
                                <span><%=GetScore(2)%></span>
                                <a href="#" class="squeeze-box">
                                    <div class="squeeze-percent" style="width: <%=GetProgressImage(2)%>%;">
                                        <div>QU</div>
                                    </div>
                                </a>
                            </div>
                            <!-- end 2 -->
                            <!-- start 3 -->
                            <div class="fifths">
                                <div class="fa fa-star"></div>
                                <span><%=GetScore(3)%></span>
                                <a href="#" class="squeeze-box">
                                    <div class="squeeze-percent" style="width: <%=GetProgressImage(3)%>%;">
                                        <div>E</div>
                                    </div>
                                </a>
                            </div>
                            <!-- end 3 -->
                            <!-- start 4 -->
                            <div class="fifths">
                                <div class="fa fa-star"></div>
                                <span><%=GetScore(4)%></span>
                                <a href="#" class="squeeze-box">
                                    <div class="squeeze-percent" style="width: <%=GetProgressImage(4)%>%;">
                                        <div>E</div>
                                    </div>
                                </a>
                            </div>
                            <!-- end 4 -->
                            <!-- start 5 -->
                            <div class="fifths">
                                <div class="fa fa-star"></div>
                                <span><%=GetScore(5)%></span>
                                <a href="#" class="squeeze-box">
                                    <div class="squeeze-percent" style="width: <%=GetProgressImage(5)%>%;">
                                        <div>ZE</div>
                                    </div>
                                </a>
                            </div>
                            <!-- end 5 -->

                        </div>
                    </div>--%>
                    <!-- end SQUEEZE -->
                    
                    <!-- Calendar -->
                    <div class="portlet light bordered squeeze">
                        <div class="month">      
                          <ul>
                            <li class="prev">&#10094;</li>
                            <li class="next">&#10095;</li>
                            <li>
                              August<br>
                              <span style="font-size:18px">2021</span>
                            </li>
                          </ul>
                        </div>

                        <ul class="weekdays">
                          <li>Mo</li>
                          <li>Tu</li>
                          <li>We</li>
                          <li>Th</li>
                          <li>Fr</li>
                          <li>Sa</li>
                          <li>Su</li>
                        </ul>

                        <ul class="days">  
                          <li>1</li>
                          <li>2</li>
                          <li>3</li>
                          <li>4</li>
                          <li>5</li>
                          <li>6</li>
                          <li>7</li>
                          <li>8</li>
                          <li>9</li>
                          <li><span class="active">10</span></li>
                          <li>11</li>
                          <li>12</li>
                          <li>13</li>
                          <li>14</li>
                          <li>15</li>
                          <li>16</li>
                          <li>17</li>
                          <li>18</li>
                          <li>19</li>
                          <li>20</li>
                          <li>21</li>
                          <li>22</li>
                          <li>23</li>
                          <li>24</li>
                          <li>25</li>
                          <li>26</li>
                          <li>27</li>
                          <li>28</li>
                          <li>29</li>
                          <li>30</li>
                          <li>31</li>
                        </ul>
                    </div>
                    <!-- End Calendar -->

                </div>
                <!-- END EXAMPLE TABLE PORTLET-->

            </div>

            <!-- TASKS Row -->
            <div class="row">
                <div class="col-md-12">

                    <!-- BEGIN TABBED PORTLET -->
                    <div class="portlet light bordered">

                        <!-- start taps TOP -->
                        <div class="portlet-title tabbable-line" style="border: none;">
                            
                            <div class="caption" style="border-bottom: 2px solid #959595; width: 100%; margin-bottom: 10px">
                                <span class="caption-subject bold uppercase">TASKS</span>
                            </div>
                            <!-- start -->
                            <ul class="nav nav-tabs home-tabs nav-justified" id="task-tabs">

                                <!-- tab 1 -->
                                <li class="active withTooltip" data-action="<%=ManageUPPRM.Catalogs.TaskCategory.Urgent %>" data-team="false" data-original-title="These are urgent items where you are the Assignee (owner)">
                                    <a href="#tasks_tab_1" data-toggle="tab">
                                        <i class="fa fa-user"></i>
                                        Urgent </a>
                                </li>

                                <!-- tab 2 -->
                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.Urgent %>" data-team="true" class="withTooltip" data-original-title="These are urgent items where you are assigned as a Viewer">
                                    <a href="#tasks_tab_2" data-toggle="tab">
                                        <i class="fa fa-users"></i>
                                        Urgent </a>
                                </li>

                                <!-- tab 3 -->
                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.All %>" data-team="false" class="withTooltip" data-original-title="These are all the items where you are the Assignee (owner)">
                                    <a href="#tasks_tab_3" data-toggle="tab">
                                        <i class="fa fa-user"></i>
                                        All </a>
                                </li>

                                <!-- tab 4 -->
                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.All %>" data-team="true" class="withTooltip" data-original-title="These are all the items where you are assigned as a Viewer">
                                    <a href="#tasks_tab_4" data-toggle="tab">
                                        <i class="fa fa-users"></i>
                                        All </a>
                                </li>

                                <!-- tab 5 -->
                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.SubmittedForApproval %>" data-team="false" class="withTooltip" data-original-title="These are items that you have submitted for approval">
                                    <a href="#tasks_tab_5" data-toggle="tab">Sub for Approval </a>
                                </li>

                                <!-- tab 6 -->
                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.ApprovalRequests %>" data-team="false" class="withTooltip" data-original-title="These are items that other users submitted to you for your approval.">
                                    <a href="#tasks_tab_6" data-toggle="tab">Approval Req </a>
                                </li>

                            </ul>
                        </div>
                        <!-- end taps TOP -->



                        <!-- ////////////////////// CONTENT ///////////////////////////////////////////// -->
                        <div class="portlet box">
                            <div class="portlet-body">
                                <div class="tab-content" id="task-tabs-content">



                                    <!-- ////////////////////// START CONTENT TAB 1 ///////////////////////////////////////////// -->
                                    <div class="tab-pane active" id="tasks_tab_1">

                                        <table class="table table-striped table-bordered table-hover" id="table_my_urgent_tasks">
                                            <thead>
                                                <tr>
                                                    <th>Name </th>
                                                    <th>Category </th>
                                                    <th>Due</th>
                                                    <th>Progress</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>

                                    </div>
                                    <!-- ////////////////////// END CONTENT TAB 1 ///////////////////////////////////////////// -->



                                    <!-- ////////////////////// START CONTENT TAB 2 ///////////////////////////////////////////// -->
                                    <div class="tab-pane" id="tasks_tab_2">

                                        <table class="table table-striped table-bordered table-hover" id="table_team_urgent_tasks">
                                            <thead>
                                                <tr>
                                                    <th>Name </th>
                                                    <th>Owner </th>
                                                    <th>Category </th>
                                                    <th>Due</th>
                                                    <th>Progress</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>

                                    </div>
                                    <!-- ////////////////////// END CONTENT TAB 2 ///////////////////////////////////////////// -->

                                    
                                    <!-- ////////////////////// START CONTENT TAB 3 ///////////////////////////////////////////// -->
                                    <div class="tab-pane" id="tasks_tab_3">

                                        <table class="table table-striped table-bordered table-hover" id="table_my_all_tasks">
                                            <thead>
                                                <tr>
                                                    <th>Name </th>
                                                    <th>Category </th>
                                                    <th>Due</th>
                                                    <th>Progress</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>

                                    </div>
                                    <!-- ////////////////////// END CONTENT TAB 3 ///////////////////////////////////////////// -->



                                    <!-- ////////////////////// START CONTENT TAB 4 ///////////////////////////////////////////// -->
                                    <div class="tab-pane" id="tasks_tab_4">

                                        <table class="table table-striped table-bordered table-hover" id="table_team_all_tasks">
                                            <thead>
                                                <tr>
                                                    <th>Name </th>
                                                    <th>Owner </th>
                                                    <th>Category </th>
                                                    <th>Due</th>
                                                    <th>Progress</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>

                                    </div>
                                    <!-- ////////////////////// END CONTENT TAB 4 ///////////////////////////////////////////// -->



                                    <!-- ////////////////////// START CONTENT TAB 5 ///////////////////////////////////////////// -->
                                    <div class="tab-pane" id="tasks_tab_5">

                                        <table class="table table-striped table-bordered table-hover" id="table_sub_for_approval">
                                            <thead>
                                                <tr>
                                                    <th>Name </th>
                                                    <th>Approver </th>
                                                    <th>Due</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>

                                    </div>
                                    <!-- ////////////////////// END CONTENT TAB 5 ///////////////////////////////////////////// -->


                                    <!-- ////////////////////// START CONTENT TAB 6 ///////////////////////////////////////////// -->
                                    <div class="tab-pane" id="tasks_tab_6">

                                        <table class="table table-striped table-bordered table-hover" id="table_approval_required">
                                            <thead>
                                                <tr>
                                                    <th>Name </th>
                                                    <th>Owner </th>
                                                    <th>Due</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>

                                    </div>
                                    <!-- ////////////////////// END CONTENT TAB 6 ///////////////////////////////////////////// -->


                                </div>
                            </div>
                        </div>
                        <!-- ////////////////////// END CONTENT ///////////////////////////////////////////// -->


                    </div>
                </div>

            </div>
            <!-- End TASKS Row -->

        </div>
        <!--  ///// END CONTENT //////////////////////////////////////// -->

    </div>
    <!-- END CONTAINER -->

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <div id="create-meeting-modal" class="modal fade" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                    <h3>Start Zoom Meeting</h3>
                </div>
                <div class="modal-body">
                    <div class="form" role="form">
                        <div class="form-body">
                            <div class="row topic-container">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Topic</label>
                                        <div class="col-md-9">
                                            <input type="text" class="topic form-control" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <%--<iframe id="startRealMeeting" src="" style="display: none;" frameborder="0" width="98%"></iframe>--%>
                                <a href="" id="startRealMeeting" class="open-full-screen-modal">Please click here to start your meeting</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn btn-success" value="Start" id="start-meeting" />
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=startZoomMeeting.ClientID%>').on('click', function () {
                $('#create-meeting-modal').modal('show');
                return false;
            });
            $('#startRealMeeting').hide();

            $('#start-meeting').on('click', function () {
                var data = { topic: $('#create-meeting-modal .topic').val() };
                callWebService({
                    url: '/ManageUpWebService.asmx/StartZoomMeeting',
                    data: JSON.stringify(data),
                    blockTarget: '#create-meeting-modal .modal-content',
                    success: function (result) {
                        //$('#create-meeting-modal').modal('hide');
                        $('#create-meeting-modal .topic-container, #start-meeting').hide();
                        $('#startRealMeeting').prop('href', result.d).trigger('click');
                        $('#create-meeting-modal').modal('hide');
                    }
                });

                return false;
            });
        });
    </script>


    <div id="training-modal" class="modal fade bs-modal-lg modal-scroll">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-body">
                        <div>
                            <div class="product-training-welcome-header">
                                <img src="/_ima/ManageUpLogo.png" />
                                <h1>Welcome <span class="product-training-username"><%=GetFullName()%></span></h1>
                                <h3>Let's get started!!</h3>
                            </div>
                            <hr />
                            <div class="product-training-content">
                                <h5>
                                    <b>Product Training</b>  
                                    <br />
                                    <br />
                                    You can access product training via our help desk.  Access that through the “HELP” button under your profile.
                                </h5>
                                <img src="/dashjs/img/training-image-1.png" class="thumbnail"/>
                                <hr class="small-divider" />
                                <h5>
                                    <b>In-product Training</b>  
                                    <br />
                                    <br />
                                    We also embedded training videos and tooltips throughout the product for real-time help access.
                                </h5>
                                <img src="/dashjs/img/training-image-2b.png" class="thumbnail" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn-danger btn" data-dismiss="modal" aria-hidden="true">Close</button>
                    </div>
                </div>
            </div>
        </div>

</asp:Content>
