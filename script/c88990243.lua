--海晶少女的集结
function c88990243.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88990243+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c88990243.condition)
	e1:SetTarget(c88990243.target)
	e1:SetOperation(c88990243.operation)
	c:RegisterEffect(e1)
end
function c88990243.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c88990243.spfilter(c,e,tp)
	return c:IsSetCard(0x12b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990243.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ct>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingMatchingCard(c88990243.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(c88990243.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(c88990243.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c88990243.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD)
		if ct>=3 then
			local g1=Duel.GetMatchingGroup(c88990243.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
			local g2=Duel.GetMatchingGroup(c88990243.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(c88990243.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
			if #g1>0 and #g2>0 and #g3>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg1=g1:Select(tp,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg2=g2:Select(tp,1,1,nil)
				sg1:Merge(sg2)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg3=g3:Select(tp,1,1,nil)
				sg1:Merge(sg3)
				Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
				Duel.SetLP(tp,Duel.GetLP(tp)-1500)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c88990243.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88990243.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_EXTRA)
end
