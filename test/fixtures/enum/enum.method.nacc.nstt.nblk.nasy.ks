enum Weekday {
	MONDAY
	TUESDAY
	WEDNESDAY
	THURSDAY
	FRIDAY
	SATURDAY
	SUNDAY

	isWeekend(): Boolean => this == SATURDAY + SUNDAY
}