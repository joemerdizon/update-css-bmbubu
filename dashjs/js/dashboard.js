var calendarEvents = [],
    modalContent,
    createNewEventContainer,
    editEventContainer;

$(document).ready(function () {
    modalContent = $('#AppointmentModal');
    createNewEventContainer = modalContent.find('#create-event-pane');
    editEventContainer = modalContent.find('#edit-event');

    modalContent.find('.username-val').val($('form').find('#username').val());

    updateCalendarEvents();

    $('#fullcalendar').fullCalendar({
        height: 400,
        header: {
            left: 'prevYear,prev,next,nextYear',
            center: 'title',
            right: 'today, month,agendaWeek,agendaDay'
        },
        events: function (start, end, callback) {
            $.ajax({
                type: "POST",
                url: '../ManageUPWebService.asmx/GetEvents',
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                data: JSON.stringify({
                    start: start.toISOString().slice(0, 10).replace(/-/g, "/"),
                    end: end.toISOString().slice(0, 10).replace(/-/g, "/"),
                    username: username
                }),
                success: function (data) {
                    var charLimit = $('#eventCharacterLimit').val();
                    var events = [];
                    $.each(data.d, function (index, el) {
                        var start = convertStringtoDate(el.StartDateUserTimeZone);
                        var end = convertStringtoDate(el.EndDateUserTimeZone);
                        var borderColor,
                            title = '';
                        //var color = el.UserTaskID != undefined ? "#6685C2" : undefined;

                        if (el.UserTaskID != undefined) {
                            if (el.IsNewTask) {
                                borderColor = '#821B1B';
                            } else if (el.IsCompleted) {
                                borderColor = '#1E5108';
                            } else {
                                var endDate = moment(end);
                                var diff = moment().local().diff(endDate, 'days');
                                if (diff < 0)
                                    diff = -diff;

                                borderColor = diff > 7 ? '#F2C403' : '#E07117';
                            }

                            title += '<span class="circle" style="color:' + borderColor + '">● </span>';
                        }

                        title += el.Name.substr(0, charLimit) + (el.Name.length > charLimit ? '...' : '');

                        events.push({
                            title: title,
                            realTitle: el.Name,
                            start: start,
                            end: end,
                            allDay: el.AllDay,
                            calendarEventId: el.CalendarEventID,
                            description: el.Description,
                            user: el.BelongsToUser,
                            repeatOptions: el.RepeatOptions,
                            borderColor: borderColor,
                            taskId: el.UserTaskID
                        });
                    });
                    callback(events);
                }
            });
        },
        loading: function (isLoading) {
            if (isLoading) {
                $('#AppointmentModal .tab-pane.active .fc-content').isLoading();
            } else {
                $('#AppointmentModal .tab-pane.active .fc-content').isLoading("hide");
            };
        },
        eventClick: function (calEvent, jsEvent, view) {
            if (calEvent.taskId != undefined) {
                window.location.href = "./ViewTaskController.aspx?TaskID=" + calEvent.taskId;
                return;
            };
            editEventContainer.scheduler('setValue', calEvent);

            editEventContainer.find('.name-input').val(calEvent.realTitle);
            editEventContainer.find('.description-input').val(calEvent.description);

            editEventContainer.find('.all-day-checkbox').prop('checked', calEvent.allDay).trigger('change');

            modalContent.find('#fullcalendar').hide('fast');
            showEventButtons(modalContent);
            editEventContainer.show('fast');
            hideErrorAndSuccessMsjs();
        }
    });

    modalContent.find('#show-my-calendar').on('click', function () {
        showCalendar(modalContent, editEventContainer);
    });

    $(".dropdown-menu li a").click(function () {
        var container = $(this).closest('div');

        var value = $(this).parent().data('value') != undefined ? $(this).parent().data('value') : $(this).text();
        var text = $(this).parent().data('text') != undefined ? $(this).parent().data('text') : $(this).text();

        container.find('.show-dropdown-select').text(text);
        container.find('.dropdown-select-value').val(value).trigger('changed').trigger('change');
    });

    $('.dropdown-select-value').on('change', function () {
        var container = $(this).closest('div'),
            actualValue = $(this).val(),
            selectedText = '';

        container.find('ul.dropdown-menu li').each(function (i, el) {
            var value = $(this).data('value') != undefined ? $(this).data('value') : $(this).find('a').text();

            if (actualValue == value) {
                selectedText = $(this).data('text') != undefined ? $(this).data('text') : $(this).find('a').text();
                return false;
            }
        });

        container.find('.show-dropdown-select').text(selectedText);
    });

    modalContent.find('#submit-event').on('click', function () {
        hideErrorAndSuccessMsjs();

        var container, action, msj, msjContainer, postEventAction;
        if (createNewEventContainer.is(':visible')) {
            container = createNewEventContainer;
            action = "CreateNewEvent";
            msj = "The event has been created successfully";
            msjContainer = container.find('.event-created-msg');
            postEventAction = function () { };
        }
        else {
            container = editEventContainer;
            action = "EditEvent";
            msj = "The event has been modified successfully";
            msjContainer = modalContent.find('#edit-success-msj');
            postEventAction = function () {
                showCalendar(modalContent, editEventContainer);
            };
        };

        container.find('.startTime-input, .endDate-input, .endTime-input').removeAttr('disabled');

        $.ajax({
            type: "POST",
            url: "../ManageUPWebService.asmx/" + action,
            data: serializeArrayToJSON(container.find('.form-horizontal').find(':input').serializeArray()),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
                modalContent.find('.tab-pane.active').isLoading();
            },
            success: function (data) {
                modalContent.find('.tab-pane.active').isLoading("hide");
                if (data.d.Success) {
                    msjContainer.text(msj).show('fast');
                    setTimeout(function () {
                        msjContainer.hide('fast');
                    }, 5000);

                    resetForm(container);
                    updateCalendarEvents();
                    postEventAction();
                } else {
                    var errorMsg = '<ul>';
                    $.each(data.d.Errors, function (i, el) {
                        errorMsg += '<li>' + el + '</li>';
                    });

                    errorMsg += '</ul>';
                    container.find('.event-error-msg').html(errorMsg).show('fast');
                    setTimeout(function () {
                        container.find('.event-error-msg').hide('fast');
                    }, 7000);

                    if (container.find('.startTime-input').hasClass('disabled')) {
                        container.find('.startTime-input, .endDate-input, .endTime-input').addAttr('disabled');
                    };
                };
            }
        });

        return false;
    });

    modalContent.find('.hide-event-buttons').on('shown.bs.tab', function () {
        hideEventButtons(modalContent);
    });

    modalContent.find('.show-event-buttons').on('shown.bs.tab', function () {
        showEventButtons(modalContent);
    });

    modalContent.find('#my-calendar-tab').on('shown.bs.tab', function () {
        showCalendar(modalContent, editEventContainer);
    });

    initializeCalendarEventForm(createNewEventContainer);
    initializeCalendarEventForm(editEventContainer);

    createNewEventContainer.find('.fuelux').scheduler();
});

var showCalendar = function (modalContent, editEventContainer) {
    if (editEventContainer.is(':visible')) {
        editEventContainer.hide();
        modalContent.find('#fullcalendar').show();
        resetForm(editEventContainer);
        hideEventButtons(modalContent);
        modalContent.find('#fullcalendar').fullCalendar('refetchEvents');
    };
};

var hideEventButtons = function (modalContent) {
    modalContent.find('#new-event-buttons').hide();
    modalContent.find('#close-button').show();
};

var showEventButtons = function (modalContent) {
    modalContent.find('#new-event-buttons').show();
    modalContent.find('#close-button').hide();
};

var hideErrorAndSuccessMsjs = function () {
    modalContent.find('#edit-success-msj, .event-created-msg, .event-error-msg').hide();
};

var getCalendarEvents = function () {
    return calendarEvents;
};

var updateCalendarEvents = function (year) {
    var events = [];
    var homeDatepicker = $("#datepicker");
    if (year == undefined) {
        if (homeDatepicker.hasClass('hasDatepicker')) {
            year = homeDatepicker.datepicker('getDate').getFullYear();
        }
        else {
            year = new Date().getFullYear();
        }
    };

    $.ajax({
        type: "POST",
        url: "../ManageUPWebService.asmx/GetBusyDays",
        data: JSON.stringify({ year: year }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            $.each(data.d, function (index, el) {
                var date = new Date(el);
                events.push(date.toString());
            });

            calendarEvents = events;

            if (!$("#datepicker").hasClass('hasDatepicker')) {
                $("#datepicker").datepicker({
                    changeYear: true,
                    onSelect: function (dateText) {
                        //format mm-dd-yyyy
                        $("#AppointmentModal").modal('show');
                        $('#AppointmentModal .tabbable .nav-tabs a:first').tab('show');
                        showCalendar(modalContent, editEventContainer);
                        $('#fullcalendar').fullCalendar('gotoDate', dateText.slice(6, 10), new Number(dateText.slice(0, 2)) - 1, dateText.slice(3, 5));
                    },
                    beforeShowDay: function (date) {
                         if ($.inArray(date.toString(), getCalendarEvents()) > -1) {
                            return [true, "busy-date"];
                        };

                        return [true, ""];
                    },
                    onChangeMonthYear: function (newYear, month) {
                        if (year != newYear) {
                            year = newYear;
                            updateCalendarEvents(newYear);
                        }
                    }
                });
            } else {
                $("#datepicker").datepicker("refresh")
            };
        },
        beforeSend: function () {
            $("#datepicker").isLoading();
        },
        complete: function () {
            $("#datepicker").isLoading('hide');
        }
    });
};