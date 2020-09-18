--侵略的泛发袭击
--need testing
function c88990222.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88990222+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c88990222.condition)
	e1:SetTarget(c88990222.target)
	e1:SetOperation(c88990222.activate)
	c:RegisterEffect(e1)
end
function c88990222.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end

function c88990222.filter(c,e,tp)
	return c:IsSetCard(0xa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990222.xyzfilter(c,mg)
	return c:IsSetCard(0xa) and c:IsXyzSummonable(mg,2,2)
end
function c88990222.fgoal(sg,exg)
	return aux.dncheck(sg) and sg:GetClassCount(Card.GetLevel)==1 and sg:GetClassCount(Card.GetLocation)==2 and exg:IsExists(Card.IsXyzSummonable,1,nil,sg)
end
function c88990222.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c88990222.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c88990222.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 
		and mg:CheckSubGroup(c88990222.fgoal,2,2,exg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE+LOCATION_DECK)
end

function c88990222.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c88990222.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c88990222.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if exg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:SelectSubGroup(tp,c88990222.fgoal,false,2,2,exg)
		if not sg or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=2 then return end
		local og=Duel.GetOperatedGroup()
		local tg=Duel.GetMatchingGroup(c88990222.xyzfilter,tp,LOCATION_EXTRA,0,nil,og)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=tg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,sg)
	end
end
