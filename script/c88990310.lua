--核成搬运员
function c88990310.initial_effect(c)
	aux.AddCodeList(c,36623431)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c88990310.cost)
	e1:SetTarget(c88990310.thtg)
	e1:SetOperation(c88990310.tgop)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c88990310.atkcon)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c88990310.descon)
	e3:SetTarget(c88990310.destg)
	e3:SetValue(c88990310.repval)
	c:RegisterEffect(e3)
end
function c88990310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88990310.thfilter(c)
	return c:IsAbleToHand() and (not c:IsCode(88990310)) and (aux.IsCodeListed(c,36623431) or c:IsCode(36623431))
end
function c88990310.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990310.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88990310.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88990310.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88990310.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1d)
end
function c88990310.atkcon(e)
	return not Duel.IsExistingMatchingCard(c88990310.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c88990310.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c88990310.rfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x1d)
end
function c88990310.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c88990310.rfilter,1,e:GetHandler()) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c88990310.repval(e,c)
	return c:IsFaceup() and c:IsSetCard(0x1d) and c~=e:GetHandler()
end
