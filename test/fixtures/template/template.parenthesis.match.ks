func foobar(date: Date) {
	return `\((date.getHours() % 12) || 12)`
}