<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" AutoEventWireup="true" CodeBehind="DaemonLogs.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.DaemonLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            updateRun = function (jobContainer, jobId, filterDateByDay, date, types) {
                jobContainer.html('');

                url = '/dashjs/admin/DaemonLogs.aspx/GetJobRuns';
                data = JSON.stringify({
                    jobID: jobId,
                    filterDateByDay: filterDateByDay == null ? true : filterDateByDay,
                    date: date ? date : "",
                    types: types ? types : ""
                });
                callbackSuccess = function (runs) {
                    if (runs.d.length > 0) {
                        jobContainer.html($('#job-content').tmpl(runs.d));
                    } else {
                        jobContainer.html("<h5 class='col-md-offset-3' style='font-style: italic; color: grey;'>There are no job runs for the selected filters</h5>")
                    }
                }

                call(url, data, callbackSuccess);
            }

            getBadgeColor = function (logLevel) {
                switch (logLevel) {
                    case "INFO":
                        return "badge-info";
                        break;
                    case "WARN":
                        return "badge-warning";
                        break;
                    case "ERROR":
                        return "badge-danger";
                        break;
                    case "FATAL":
                        return "badge-danger";
                        break;
                    default:
                        return "badge-default"
                }
            }

            showRun = function (jobRunID) {
                url = '/dashjs/admin/DaemonLogs.aspx/GetJobRunLogs';
                data = JSON.stringify({ jobRunID: jobRunID });
                callbackSuccess = function (run) {
                    $("#JobRunDetailsContainer").html($('#job-run-content').tmpl(run.d));
                    $("#JobRunDetailsModal").modal('show');
                };

                call(url, data, callbackSuccess);
            };

            showLogDetails = function (daemonLogID) {
                url = '/dashjs/admin/DaemonLogs.aspx/GetLogDetails';
                data = JSON.stringify({ daemonLogID: daemonLogID });
                callbackSuccess = function (log) {
                    $("#LogDetailsContainer").html($('#log-details-content').tmpl(log.d));
                    $("#LogDetailsModal").modal('show');
                };

                call(url, data, callbackSuccess);
            };

            resetJobFilters = function () {
                $('#filter-date-switch').bootstrapSwitch('state', true);
                $("#filter-datetime-picker-job").datetimepicker("_setDate", null, 'date');
                $("#filter-type-input-job").select2("val", "");
            };

            resetRunFilters = function () {
                $("#filter-type-input-run").select2("val", "", true);
            };

            filterRunDetails = function (types) {
                $("#JobRunDetailsContainer .job-run-log").each(function (index) {
                    var level = $(this).data("level");

                    if (types.length == 0 || $.inArray(level, types) !== -1) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            };

            $(".reload").click(function () {
                resetJobFilters();

                //Update runs
                var jobId = $(this).data("jobId");
                var jobClass = $(this).data("jobClass");
                var jobContainer = $('#' + jobClass);

                updateRun(jobContainer, jobId);

                //Update last run
                var lastRunContainer = $('#' + jobClass + '-last-run');
                lastRunContainer.html('');

                url = '/dashjs/admin/DaemonLogs.aspx/GetJobLastRun';
                data = JSON.stringify({ jobId: jobId });
                callbackSuccess = function (lastRun) {
                    lastRunContainer.html(lastRun.d);
                    $(".withTooltip").tooltip({ container: 'body' });
                }

                call(url, data, callbackSuccess);
            });

            //Runs date filter
            var byDayOptions = {
                autoclose: true,
                format: "mm/dd/yyyy",
                pickerPosition: "bottom-right",
                initialDate: new Date(new Date()),
                minView: 'month',
            };

            var byHourOptions = {
                autoclose: true,
                format: "mm/dd/yyyy hh:ii",
                pickerPosition: "bottom-right",
                minuteStep: 60,
                initialDate: new Date(new Date().setMinutes(0)),
                minView: 'day',
            };

            $("#filter-datetime-picker-job").datetimepicker(byDayOptions);

            //Runs date switch
            $("#filter-date-switch").bootstrapSwitch({
                onText: "Day",
                offText: "Hour",
                size: "small",
                onColor: "default",
                offColor: "warning"
            }).on("switchChange.bootstrapSwitch", function (event, state) {
                var currentDate = $("#date-input").val();
                currentDate = currentDate ? new Date(new Date(new Date(currentDate).setHours(0)).setMinutes(0)) : null;

                $('#filter-datetime-picker-job').datetimepicker('remove');

                if (state) {    //true == By day
                    $("#filter-datetime-picker-job").datetimepicker(byDayOptions);
                } else {        //false == By hour
                    $("#filter-datetime-picker-job").datetimepicker(byHourOptions);
                }

                $("#filter-datetime-picker-job").datetimepicker("_setDate", currentDate, 'date');
            });

            //Runs type filter
            var formatTypeFilterRuns = function (type) {
                if (type.id == "Success")
                    return "<span class='badge badge-roundless badge-info'>SUCCESS</span>";
                if (type.id == "Warning")
                    return "<span class='badge badge-roundless badge-warning'>WARN</span>";
                if (type.id == "Error")
                    return "<span class='badge badge-roundless badge-danger'>ERROR</span>";
            };

            var formatTypeTagCssClassRuns = function (type) {
                if (type.id == "Success")
                    return "tag-info";
                if (type.id == "Warning")
                    return "tag-warning";
                if (type.id == "Error")
                    return "tag-danger";
            }

            $('#filter-type-input-job').select2({
                tags: ["Success", "Warning", "Error"],
                placeholder: "Show only runs containing...",
                formatResult: formatTypeFilterRuns,
                formatSelection: formatTypeFilterRuns,
                formatSelectionCssClass: formatTypeTagCssClassRuns,
                escapeMarkup: function (t) { return t; }
            });


            //Logs type filter
            var formatTypeFilterLogs = function (type) {
                if (type.id == "INFO")
                    return "<span class='badge badge-roundless badge-info'>INFO</span>";
                if (type.id == "WARN")
                    return "<span class='badge badge-roundless badge-warning'>WARN</span>";
                if (type.id == "ERROR")
                    return "<span class='badge badge-roundless badge-danger'>ERROR</span>";
            };

            var formatTypeTagCssClassLogs = function (type) {
                if (type.id == "INFO")
                    return "tag-info";
                if (type.id == "WARN")
                    return "tag-warning";
                if (type.id == "ERROR")
                    return "tag-danger";
            }

            $('#filter-type-input-run').select2({
                tags: ["INFO", "WARN", "ERROR"],
                placeholder: "Show only...",
                formatResult: formatTypeFilterLogs,
                formatSelection: formatTypeFilterLogs,
                formatSelectionCssClass: formatTypeTagCssClassLogs,
                escapeMarkup: function (t) { return t; }
            }).on("change", function (event) {
                filterRunDetails(event.val)
            });


            $(".filter-job").click(function () {
                $("#FiltersModal #job-filter").data("jobId", $(this).data("jobId"));
                $("#FiltersModal #job-filter").data("jobClass", $(this).data("jobClass"));
                $("#FiltersModal").modal('show');
            })

            $("#job-filter").click(function () {
                var jobId = $(this).data("jobId");
                var jobClass = $(this).data("jobClass");
                var jobContainer = $('#' + jobClass);
                var date = $("#date-input").val();
                var types = $("#filter-type-input-job").select2("val").join();
                var filterDateByDay = $('#filter-date-switch').bootstrapSwitch('state');

                updateRun(jobContainer, jobId, filterDateByDay, date, types);

                $("#FiltersModal").modal('hide');
            });

            $('#JobRunDetailsModal').on('hidden.bs.modal', function (e) {
                resetRunFilters();
            });

            $(".reload").trigger("click");
        });
    </script>
    <style>
        .modal-open {
            overflow-y: hidden !important;
            margin-right: 18px !important;
        }
        .fa-filter, .fa-filter:hover, .fa-filter:focus {
            display: inline-block;
            top: -3px;
            position: relative;
            font-size: 14px;
            font-family: FontAwesome;
            color: #ACACAC;
        }
        .tag-info {
            background-color: #89C4F4 !important;
        }
        .tag-warning {
            background-color: #dfba49 !important;
        }
        .tag-danger {
            background-color: #F3565D !important;
        }
        .filter-date-switch-container {
            padding-top: 3px;
        }
        .select2-container {
          z-index: 100002 !important;
        }
        .select2-drop-mask {
          z-index:100000 !important;
        }
        .select2-drop-active {
          z-index:100001 !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row-fluid">
                <h3 class="page-title">Daemon Status <small>View real time logs from the jobs running on the daemon application</small></h3>
            </div>
            
            <div class="row">
                <% foreach (var job in GetJobs())
                    { %>
                <div class="col-md-6">
                    <div class="portlet portlet light bordered">
                        <div class="portlet-title">
                            <div class="caption">
                                <i class="fa fa-align-left"></i><%= job.Name %> <span style="color: rgba(130, 148, 154, 0.51); font-style: italic;">Last Run: <span id="<%=job.Class %>-last-run"><%=job.LastRun %></span></span>
                            </div>
                            <div class="tools">
                                <a href="javascript:;" data-job-class="<%= job.Class %>" data-job-id="<%= job.JobId %>" class="fa fa-filter filter-job tooltips" data-original-title="Filter" data-placement="top"></a>
                                <a href="javascript:;" class="collapse"></a>
                                <a href="javascript:;" data-load="true" data-job-id="<%= job.JobId %>" data-job-class="<%= job.Class %>" class="reload white" data-original-title="Reset filters and reload"></a>
                                <a href="javascript:;" data-job-class="<%= job.Class %>" class="fullscreen"></a>
                            </div>
                        </div>
                        <div class="portlet-body">
                            <div class="scroller" id="<%= job.Class %>-scroller" data-height="400">
                                <ul id="<%= job.Class %>" class="feeds">
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    <%--Job Details--%>
    <script type="text/x-jquery-tmpl" id="job-content">
        <li style="cursor: pointer" onclick="showRun(${ProcessJobRunID})">
            <div class="col-md-8" style="padding-top: 3px; padding-bottom: 5px;">
                <div class="cont">
                    <div class="col-md-4">
                        <span class="badge badge-roundless badge-danger withTooltip" data-placement="top" data-original-title="Errors">${ErrorCount}</span>
                        <span class="badge badge-roundless badge-warning withTooltip" data-placement="top" data-original-title="Warnings">${WarningCount}</span>
                        <span class="badge badge-roundless badge-info withTooltip" data-placement="top" data-original-title="Successes">${SuccessCount}</span>
                    </div>
                    <div class="col-md-8">
                        <div class="desc">${Summary}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 pull right" style="text-align: right;">
                <div style="display: inline-block; vertical-align: middle; color: rgba(130, 148, 154, 0.51); font-style: italic;">${StartDateAsString}</div>
            </div>
        </li>
    </script>

    <%--Run Details--%>
    <script type="text/x-jquery-tmpl" id="job-run-content">
        <li class="job-run-log" data-level="${Level}" style="cursor: pointer" onclick="showLogDetails(${DaemonLogID})">
            <div class="col-md-8" style="padding-top: 3px; padding-bottom: 5px;">
                <div class="cont">
                    <div class="col-md-2">
                        <span class="badge badge-roundless ${getBadgeColor(Level)}">${Level}</span>
                    </div>
                    <div class="col-md-10">
                        <div class="desc">${Message}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 pull right" style="text-align: right;">
                <div style="display: inline-block; vertical-align: middle; color: rgba(130, 148, 154, 0.51); font-style: italic;">${DateAsShortDateString}</div>
            </div>
        </li>
    </script>

    <%--Log Details--%>
    <script type="text/x-jquery-tmpl" id="log-details-content">
        <div class="form-group">
            <label class="col-md-2 control-label">Level</label>
            <div class="col-md-9">
                <p class="form-control-static"><span class="label ${getBadgeColor(Level)}">${Level}</span></p>
            </div>
        </div>
        <div class="form-group">
            <label class="col-md-2 control-label">Date</label>
            <div class="col-md-9">
                <p class="form-control-static">${DateAsShortDateString}</p>
            </div>
        </div>
        <div class="form-group">
            <label class="col-md-2 control-label">Message</label>
            <div class="col-md-9">
                <p class="form-control-static well">${Message}</p>
            </div>
        </div>
        {{if Exception}}
        <div class="form-group">
            <label class="col-md-2 control-label">Exception</label>
            <div class="col-md-9">
                <p class="form-control-static well" style="word-wrap: break-word; width: 100%;">${Exception}</p>
            </div>
        </div>
        {{/if}}
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <div class="modal fade bs-modal-lg" id="JobRunDetailsModal" style="z-index: 99999">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                        <h4>Job Run Details</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="form-group">
                                <label class="control-label col-md-2">Filter by Type</label>
                                <div class="col-md-8">
                                    <input type="hidden" id="filter-type-input-run" class="form-control filter-type-input-run" />
                                </div>
                                <div class="col-md-2">
                                    <button type="button" class="btn btn-info" onclick="resetRunFilters()"><i class="fa fa-refresh"></i> Reset</button>
                                </div>
                            </div>
                        </div>
                        <hr class="modal-divider" style="margin-top: 0px;" />
                        <div class="scroller" id="job-run-scroller" data-height="400">
                            <ul id="JobRunDetailsContainer" class="feeds"></ul>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-modal-lg" id="LogDetailsModal" style="z-index: 99999">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                        <h4>Log Details</h4>
                    </div>
                    <div class="modal-body" id="LogDetailsContainer">

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="FiltersModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                        <h4>Filter</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="control-label col-md-2 col-md-offset-1">Date</label>
                            <div class="col-md-6">
                                <div class="input-group date form_datetime" id="filter-datetime-picker-job">
                                    <input type="text" size="16" readonly="readonly" class="form-control" id="date-input"/>
                                    <span class="input-group-btn">
                                        <button class="btn default date-set" type="button">
                                            <i class="fa fa-calendar"></i>
                                        </button>
                                    </span>
                                </div>
                            </div>
                            <div class="col-md-2 filter-date-switch-container">
                                <input id="filter-date-switch" type="checkbox" checked="checked" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-2 col-md-offset-1">Type</label>
                            <div class="col-md-6">
                                <input type="hidden" id="filter-type-input-job" class="form-control filter-type-input-job" />
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-3">
                                <button type="button" class="btn btn-default btn-sm" onclick="resetJobFilters()"><i class="fa fa-refresh"></i> Reset Filters</button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-info" data-job-class="" data-job-id="" id="job-filter">Filter</button>
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
