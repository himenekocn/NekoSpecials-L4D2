

public any NekoVote_REPlHandle(Handle plugin, int numParams)
{
	return GetMyHandle();
}

public any NekoVote_REVoteStatus(Handle plugin, int numParams)
{
	return NCvar[Neko_CanSwitch].BoolValue;
}