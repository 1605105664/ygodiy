--邪心英雄 复仇瘴魔
function c88990285.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,88990285)
	e1:SetTarget(c88990285.tg)
	e1:SetOperation(c88990285.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,88990286)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c88990285.actg)
	e3:SetOperation(c88990285.acop)
	c:RegisterEffect(e3)
end
function c88990285.ctfilter(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER)
end
function c88990285.schfilter(c,e,tp)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) 
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c88990285.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.GetMatchingGroupCount(c88990285.ctfilter,tp,LOCATION_GRAVE,0,nil)
	local b2=Duel.GetTargetCount(c88990285.schfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chkc then return chkc:IsControler(tp) 
		and chkc:IsLocation(LOCATION_GRAVE) and c88990285.schfilter(chkc,e,tp) end
	if chk==0 then return b1>0 or b2>0 end
	local off=1
	local ops={}
	local opval={}
	if b1>0 then
		ops[off]=aux.Stringid(88990285,1)
		opval[off]=0
		off=off+1
	end
	if b2>0 then
		ops[off]=aux.Stringid(88990285,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(b1*300)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,b1*300)
	else
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectTarget(tp,c88990285.schfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
	end
end
function c88990285.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local val=Duel.GetMatchingGroupCount(c88990285.ctfilter,tp,LOCATION_GRAVE,0,nil)*300
		Duel.Damage(p,val,REASON_EFFECT)
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and not tc:IsHasEffect(EFFECT_NECRO_VALLEY)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
function c88990285.acfilter(c,tp)
	return c:IsCode(72043279) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c88990285.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990285.acfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c88990285.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c88990285.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
