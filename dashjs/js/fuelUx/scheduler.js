// SCHEDULER CONSTRUCTOR AND PROTOTYPE

var Scheduler = function (element, options) {
    var self = this;

    this.$element = $(element);
    this.options = $.extend({}, $.fn.scheduler.defaults, options);

    // cache elements
    this.$startDate = this.$element.find('.startDate-input');
    this.$startTime = this.$element.find('.startTime-input');

    this.$endEventDate = this.$element.find('.endDate-input');
    this.$endEventTime = this.$element.find('.endTime-input');

    this.$timeZone = this.$element.find('#TimeZoneDropDownList');

    this.$repeatIntervalPanel = this.$element.find('.repeat-interval-panel');
    this.$repeatIntervalSelect = this.$element.find('.repeat-interval .select select.dropdown-select-value');
    this.$repeatIntervalSpinner = this.$element.find('.repeat-interval-panel .spinner');
    this.$repeatIntervalTxt = this.$element.find('.repeat-interval-text');

    this.$end = this.$element.find('.scheduler-end');
    this.$endAfter = this.$end.find('.spinner');
    this.$endSelect = this.$end.find('select.dropdown-select-value');
    this.$endDate = this.$end.find('.end-date-container');

    // panels
    this.$recurrencePanels = this.$element.find('.recurrence-panel');

    // bind events
    this.$element.find('.scheduler-weekly .btn-group .btn').on('click', function (e, data) {
        self.changed(e, data, true);
    });

    this.$element.find('.combobox select.dropdown-select-value').on('change', $.proxy(this.changed, this));
    this.$element.find('.end-date-container input').on('change', $.proxy(this.changed, this));
    this.$element.find('.select select.dropdown-select-value').on('change', $.proxy(this.changed, this));
    this.$element.find('.spinner').on('changed', $.proxy(this.changed, this));
    this.$element.find('.radio-list input').on('change', $.proxy(this.changed, this));
    this.$element.find('.scheduler-monthly label.radio input[type="radio"], .scheduler-yearly label.radio input[type="radio"]').on('change', $.proxy(this.changed, this));

    this.$repeatIntervalSelect.on('change', $.proxy(this.repeatIntervalSelectChanged, this));
    this.$endSelect.on('change', $.proxy(this.endSelectChanged, this));

    //initialize sub-controls

    this.$repeatIntervalSpinner.spinner();
    this.$endAfter.spinner();
    this.$endDate.find('.date-picker').datepicker();

    this.$repeatIntervalSelect.trigger('change');
    this.$endSelect.trigger('change');
};

Scheduler.prototype = {
    constructor: Scheduler,

    changed: function (e, data, propagate) {
        if (!propagate) {
            e.stopPropagation();
        }
        this.$element.trigger('changed', {
            data: (data !== undefined) ? data : $(e.currentTarget).data(),
            originalEvent: e,
            value: this.getValue()
        });
    },

    disable: function () {
        this.toggleState('disable');
    },

    enable: function () {
        this.toggleState('enable');
    },

    // called when the end range changes
    // (Never, After, On date)
    endSelectChanged: function (e, data) {
        var val;

        if (!data) {
            val = this.$endSelect.val();
        } else {
            val = data.value;
        }

        // hide all panels
        this.$endAfter.hide();
        this.$endDate.hide();

        if (val === 'after') {
            this.$endAfter.show();
        } else if (val === 'date') {
            this.$endDate.show();
        }
    },

    getValue: function () {
        // FREQ = frequency (hourly, daily, monthly...)
        // BYDAY = when picking days (MO,TU,WE,etc)
        // BYMONTH = when picking months (Jan,Feb,March) - note the values should be 1,2,3...
        // BYMONTHDAY = when picking days of the month (1,2,3...)
        // BYSETPOS = when picking First,Second,Third,Fourth,Last (1,2,3,4,-1)

        var interval = this.$repeatIntervalSpinner.find('input').val();
        var pattern = '';
        var repeat = this.$repeatIntervalSelect.val();
        var timeZone = this.$timeZone.val();
        var getFormattedDate = function (dateObj, dash) {
            var fdate = '';
            var item;

            //fdate += dateObj.getFullYear();
            //fdate += dash;
            //item = dateObj.getMonth() + 1;  //because 0 indexing makes sense when dealing with months /sarcasm
            //fdate += (item < 10) ? '0' + item : item;
            //fdate += dash;
            //item = dateObj.getDate();
            //fdate += (item < 10) ? '0' + item : item;

            return fdate;
        };
        var day, days, hasAm, hasPm, month, pos, type;

        if (repeat === 'none') {
            //pattern = 'FREQ=DAILY;INTERVAL=1;COUNT=1&';
            pattern = '';
        }
        else if (repeat === 'hourly') {
            pattern = 'FREQ=HOURLY&';
            pattern += 'INTERVAL=' + interval + '&';
        }
        else if (repeat === 'daily') {
            pattern += 'FREQ=DAILY&';
            pattern += 'INTERVAL=' + interval + '&';
        }
        else if (repeat === 'weekdays') {
            pattern += 'FREQ=DAILY&';
            pattern += 'BYDAY=MO,TU,WE,TH,FR&';
            pattern += 'INTERVAL=1&';
        }
        else if (repeat === 'weekly') {
            days = [];
            this.$element.find('.scheduler-weekly .btn-group .active').each(function () {
                days.push($(this).data().value);
            });

            pattern += 'FREQ=WEEKLY&';
            pattern += 'BYDAY=' + days.join(',') + '&';
            pattern += 'INTERVAL=' + interval + '&';
        }
        else if (repeat === 'monthly') {
            pattern += 'FREQ=MONTHLY&';
            pattern += 'INTERVAL=' + interval + '&';

            type = parseInt(this.$element.find('input[name=scheduler-month]:checked').val(), 10);
            if (type === 1) {
                day = parseInt(this.$element.find('.scheduler-monthly-date .select select.dropdown-select-value').val(), 10);
                pattern += 'BYMONTHDAY=' + day + '&';
            }
            else if (type === 2) {
                days = this.$element.find('.month-days select.dropdown-select-value').val();
                pos = this.$element.find('.month-day-pos select.dropdown-select-value').val();

                pattern += 'BYDAY=' + days + '&';
                pattern += 'BYSETPOS=' + pos + '&';
            }
        }
        else if (repeat === 'yearly') {
            pattern += 'FREQ=YEARLY&';

            type = parseInt(this.$element.find('input[name=scheduler-year]:checked').val(), 10);
            if (type === 1) {
                month = this.$element.find('.scheduler-yearly-date .year-month select.dropdown-select-value').val();
                day = this.$element.find('.year-month-day select.dropdown-select-value').val();

                pattern += 'BYMONTH=' + month + '&';
                pattern += 'BYMONTHDAY=' + day + '&';
            }
            else if (type === 2) {
                days = this.$element.find('.year-month-days select.dropdown-select-value').val();
                pos = this.$element.find('.year-month-day-pos select.dropdown-select-value').val();
                month = this.$element.find('.scheduler-yearly-day .year-month select.dropdown-select-value').val();

                pattern += 'BYDAY=' + days + '&';
                pattern += 'BYSETPOS=' + pos + '&';
                pattern += 'BYMONTH=' + month + '&';
            }
        }

        var end = this.$endSelect.val();
        var duration = '';

        // if both UNTIL and COUNT are not specified, the recurrence will repeat forever
        // http://tools.ietf.org/html/rfc2445#section-4.3.10
        if (repeat !== 'none') {
            if (end === 'after') {
                duration = 'COUNT=' + this.$endAfter.find('input').val() + '&';
            }
            else if (end === 'date') {
                duration = 'UNTIL=' + this.$endDate.find('input').val() + '&';
            }
        }

        pattern += duration;

        var data = {
            recurrencePattern: pattern
        };

        this.$element.find('#repeatPattern, .repeatPattern-value').val(pattern);

        return data;
    },

    // called when the repeat interval changes
    // (None, Hourly, Daily, Weekdays, Weekly, Monthly, Yearly
    repeatIntervalSelectChanged: function (e, data) {
        var selectedItem, val, txt;

        if (!data) {
            selectedItem = this.$repeatIntervalSelect.val();
            val = selectedItem;
            txt = selectedItem;
        } else {
            val = data.value;
            txt = data.text;
        };

        switch (val.toLowerCase()) {
            case 'hourly':
                this.$repeatIntervalTxt.text('Hour(s)');
                this.$repeatIntervalPanel.show();
                break;
            case 'daily':
                this.$repeatIntervalTxt.text('Day(s)');
                this.$repeatIntervalPanel.show();
                break;
            case 'weekly':
                this.$repeatIntervalTxt.text('Week(s)');
                this.$repeatIntervalPanel.show();
                break;
            case 'monthly':
                this.$repeatIntervalTxt.text('Month(s)');
                this.$repeatIntervalPanel.show();
                break;
            default:
                this.$repeatIntervalPanel.hide();
                break;
        }

        // hide all panels
        this.$recurrencePanels.hide();

        // show panel for current selection
        this.$element.find('.scheduler-' + val).show();

        // the end selection should only be shown when
        // the repeat interval is not "None (run once)"
        if (val === 'none') {
            this.$end.hide();
        }
        else {
            this.$end.show();
        }
    },

    setValue: function (options) {
        var hours, i, item, l, minutes, period, recur, temp;

        if (options.start) {
            var startDateTime = moment(options.start);
            this.$startDate.val(startDateTime.format('MM/DD/YYYY')).trigger('change');
            this.$startTime.val(startDateTime.format('hh:mm A')).trigger('change').trigger('blur.timepicker');
        };

        if (options.end) {
            var endDateTime = moment(options.end);
            this.$endEventDate.val(endDateTime.format('MM/DD/YYYY')).trigger('change');
            this.$endEventTime.val(endDateTime.format('hh:mm A')).trigger('change').trigger('blur.timepicker');
        };

        if (options.calendarEventId) {
            this.$element.find('.calendar-event-id-input').val(options.calendarEventId);
        };

        if (options.repeatOptions) {
            recur = {};
            temp = options.repeatOptions.toUpperCase().split('&');
            for (i = 0, l = temp.length; i < l; i++) {
                if (temp[i] !== '') {
                    item = temp[i].split('=');
                    recur[item[0]] = item[1];
                }
            }

            if (recur.FREQ === 'DAILY') {
                if (recur.BYDAY === 'MO,TU,WE,TH,FR') {
                    item = 'weekdays';
                } else {
                    if (recur.INTERVAL === '1' && recur.COUNT === '1') {
                        item = 'none';
                    } else {
                        item = 'daily';
                    }
                }
            } else if (recur.FREQ === 'HOURLY') {
                item = 'hourly';
            } else if (recur.FREQ === 'WEEKLY') {
                if (recur.BYDAY) {
                    item = this.$element.find('.scheduler-weekly .btn-group');
                    item.find('button').removeClass('active');
                    temp = recur.BYDAY.split(',');
                    for (i = 0, l = temp.length; i < l; i++) {
                        item.find('button[data-value="' + temp[i] + '"]').addClass('active');
                    }
                }
                item = 'weekly';
            } else if (recur.FREQ === 'MONTHLY') {
                this.$element.find('.scheduler-monthly input:checked').prop('checked', false);
                if (recur.BYMONTHDAY) {
                    temp = this.$element.find('.scheduler-monthly-date');
                    temp.find('input').prop('checked', true);
                    temp.find('.select select.dropdown-select-value').val(recur.BYMONTHDAY).trigger('change');
                } else if (recur.BYDAY) {
                    temp = this.$element.find('.scheduler-monthly-day');
                    temp.find('input').prop('checked', true);
                    if (recur.BYSETPOS) {
                        temp.find('.month-day-pos select.dropdown-select-value').val(recur.BYSETPOS).trigger('change');
                    }
                    temp.find('.month-days select.dropdown-select-value').val(recur.BYDAY).trigger('change');
                }
                item = 'monthly';
            } else if (recur.FREQ === 'YEARLY') {
                this.$element.find('.scheduler-yearly input:checked').prop('checked', false);
                if (recur.BYMONTHDAY) {
                    temp = this.$element.find('.scheduler-yearly-date');
                    temp.find('input').prop('checked', true);
                    if (recur.BYMONTH) {
                        temp.find('.year-month select.dropdown-select-value').val(recur.BYMONTH).trigger('change');
                    }
                    temp.find('.year-month-day select.dropdown-select-value').val(recur.BYMONTHDAY).trigger('change');
                } else if (recur.BYSETPOS) {
                    temp = this.$element.find('.scheduler-yearly-day');
                    temp.find('input').prop('checked', true);
                    temp.find('.year-month-day-pos select.dropdown-select-value').val(recur.BYSETPOS).trigger('change');
                    if (recur.BYDAY) {
                        temp.find('.year-month-days select.dropdown-select-value').val(recur.BYDAY).trigger('change');
                    }
                    if (recur.BYMONTH) {
                        temp.find('.year-month select.dropdown-select-value').val(recur.BYMONTH).trigger('change');
                    }
                }
                item = 'yearly';
            } else {
                item = 'none';
            }

            if (recur.COUNT) {
                this.$endAfter.find('input').val(parseInt(recur.COUNT, 10));
                this.$endSelect.val('after').trigger('change');
            } else if (recur.UNTIL) {
                temp = recur.UNTIL;
                if (temp.length === 8) {
                    temp = temp.split('');
                    temp.splice(4, 0, '-');
                    temp.splice(7, 0, '-');
                    temp = temp.join('');
                }
                this.$endDate.find('input').val(temp);
                this.$endSelect.val('date').trigger('change');
            }
            this.endSelectChanged();

            if (recur.INTERVAL) {
                this.$repeatIntervalSpinner.spinner('value', parseInt(recur.INTERVAL, 10));
            }
            this.$repeatIntervalSelect.val(item).trigger('change');
            this.repeatIntervalSelectChanged();
        }
    },

    toggleState: function (action) {
        this.$element.find('.combobox').combobox(action);
        this.$element.find('.end-date-container').datepicker(action);
        this.$element.find('.select select.dropdown-select-value').val(action);
        this.$element.find('.spinner').spinner(action);
        this.$element.find('.radio').radio(action);

        if (action === 'disable') {
            action = 'addClass';
        } else {
            action = 'removeClass';
        }
        this.$element.find('.scheduler-weekly .btn-group')[action]('disabled');
    },

    value: function (options) {
        if (options) {
            return this.setValue(options);
        } else {
            return this.getValue();
        }
    }
};

// SCHEDULER PLUGIN DEFINITION

$.fn.scheduler = function (option) {
    var args = Array.prototype.slice.call(arguments, 1);
    var methodReturn;

    var $set = this.each(function () {
        var $this = $(this);
        var data = $this.data('scheduler');
        var options = typeof option === 'object' && option;

        if (!data) $this.data('scheduler', (data = new Scheduler(this, options)));
        if (typeof option === 'string') methodReturn = data[option].apply(data, args);
    });

    return (methodReturn === undefined) ? $set : methodReturn;
};

$.fn.scheduler.defaults = {};

$.fn.scheduler.Constructor = Scheduler;

// SCHEDULER DATA-API

$(function () {
    $('body').on('mousedown.scheduler.data-api', '.scheduler', function () {
        var $this = $(this);
        if ($this.data('scheduler')) return;
        $this.scheduler($this.data());
    });
});

var initializeCalendarEventForm = function (container) {
    //(function (container) {
    var startDate = container.find('.startDate-input');
    var endDate = container.find('.endDate-input');
    var startTime = container.find('.startTime-input');
    var endTime = container.find('.endTime-input');

    var initStartDateAndTime = function (container) {
        container.find('.startDate-input, .startTime-input').on('change', function () {
            updateEndDateAndTime(container);
        });

        container.find('.endDate-input, .endTime-input').on('change', function () {
            updateTimeDiff(container);
        });
    };

    var startEndMinutesDiff;

    var updateEndDateAndTime = function (container) {
        if (startDate.val() == '' || startTime.val() == '') {
            updateTimeDiff(container);
            return;
        };

        var startDateTime = moment(startDate.val() + ' ' + startTime.val(), 'MM/DD/YYYY hh:mm A', true);

        if (startDateTime.isValid()) {
            var endDateTime = startDateTime.add('minutes', startEndMinutesDiff);
            try {
                endDate.val(endDateTime.format('MM/DD/YYYY')).trigger('change').datepicker('update');
            }
            catch (e) {
            }

            endTime.val(endDateTime.format('hh:mm A')).trigger('change').trigger('blur.timepicker');
        };

        updateTimeDiff();
    };

    var updateTimeDiff = function (container) {
        if (startDate.val() != '' && startTime.val() != '' && endDate.val() != '' && endTime.val() != '') {
            var startDateTime = moment(startDate.val() + ' ' + startTime.val(), 'MM/DD/YYYY hh:mm A', true);
            var endDateTime = moment(endDate.val() + ' ' + endTime.val(), 'MM/DD/YYYY hh:mm A', true);

            if (startDateTime.isValid() && endDateTime.isValid()) {
                var diffMinutes = endDateTime.diff(startDateTime, 'minutes');
                if (diffMinutes >= 0) {
                    startEndMinutesDiff = diffMinutes;
                    endDate.closest('.control-group').removeClass('error');
                    return;
                }
                else {
                    endDate.closest('.control-group').addClass('error');
                };
            }
        }
        else {
            endDate.closest('.control-group').removeClass('error');
        };

        startEndMinutesDiff = 60;
    }

    container.find('select.dropdown-select-value').each(function () {
        $(this).data('defaultvalue', $(this).val());
    });

    var allDayChangeEvent = function () {
        if ($(this).is(':checked')) {
            container.find('.startTime-input, .endDate-input, .endTime-input').val('').attr('disabled', 'disabled').addClass('disabled');
            container.find('#create-event-pane .button-disabled').attr('disabled', 'disabled').addClass('disabled');
            container.find('.all-day-input').val('true');
        } else {
            container.find('.startTime-input, .endDate-input, .endTime-input, #create-event-pane .button-disabled').removeAttr('disabled').removeClass('disabled');
            container.find('.all-day-input').val('false');
        };
    };

    container.find('.all-day-checkbox').on('click', allDayChangeEvent);
    container.find('.all-day-checkbox').on('change', allDayChangeEvent);

    if (container.timepicker != undefined) {
        container.find('.startTime-input, .endTime-input').timepicker({ defaultTime: false });
    };

    initStartDateAndTime(container);
    //})(container);
};

var resetForm = function (container) {
    if (typeof container === "undefined") {
        container = $('form');
    };

    container.find('.name-input, .description-input, .startDate-input, .startTime-input, .endDate-input, .endTime-input').val('').trigger('change');
    container.find('.all-day-checkbox').prop("checked", false).trigger('change');
    container.find('.btn.active').removeClass("active");

    container.find('select.dropdown-select-value').each(function () {
        var selectedValue = $(this).data('defaultvalue') != '' ? $(this).data('defaultvalue') : $(this).find('option:first').val();
        $(this).val(selectedValue).trigger('change');
    });
};