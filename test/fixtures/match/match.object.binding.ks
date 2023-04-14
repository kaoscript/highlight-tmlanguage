match Router.matchArguments(@assessment, @thisType, @arguments, @matchingMode, this) {
	is LenientCallMatchResult with result {
	}
	is PreciseCallMatchResult with { matches } {
	}
	else {
	}
}