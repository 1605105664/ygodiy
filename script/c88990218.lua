--电子化猫机灵
function c88990218.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c88990218.spcost)
	e1:SetTarget(c88990218.sptg)
	e1:SetOperation(c88990218.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c88990218.reptg)
	e2:SetValue(c88990218.repval)
	e2:SetOperation(c88990218.repop)
	c:RegisterEffect(e2)
end
function c88990218.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990218.filter(c,e,sp)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c88990218.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990218.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function c88990218.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c88990218.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(88990218,RESET_EVENT+RESETS_STANDARD,0,1,c:GetFieldID())
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabel(c:GetFieldID())
	e2:SetLabelObject(g)
	e2:SetCondition(c88990218.descon)
	e2:SetOperation(c88990218.desop)
	Duel.RegisterEffect(e2,tp)
end
function c88990218.desfilter(c,fid)
	return c:GetFlagEffectLabel(88990218)==fid
end
function c88990218.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c88990218.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c88990218.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c88990218.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
function c88990218.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c88990218.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c88990218.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c88990218.repval(e,c)
	return c88990218.repfilter(c,e:GetHandlerPlayer())
end
function c88990218.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
