--战华之矢-黄升
function c88990328.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88990328)
	e1:SetCost(c88990328.spcost)
	e1:SetTarget(c88990328.sptg)
	e1:SetOperation(c88990328.spop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c88990328.dircon)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,88990329)
	e3:SetCondition(c88990328.rmcon)
	e3:SetTarget(c88990328.rmtg)
	e3:SetOperation(c88990328.rmop)
	c:RegisterEffect(e3)
end
function c88990328.costfilter(c)
	return c:IsSetCard(0x137) and c:IsAbleToRemoveAsCost()
end
function c88990328.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990328.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c88990328.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c88990328.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88990328.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c88990328.dirfilter(c,g)
	return g:IsContains(c)
end
function c88990328.dircon(e)
	local cg=e:GetHandler():GetColumnGroup()
	return not Duel.IsExistingMatchingCard(c88990328.dirfilter,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil,cg)
end
function c88990328.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
end
function c88990328.filter(c,g)
	return g:IsContains(c) and c:IsAbleToRemove()
end
function c88990328.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetHandler():GetColumnGroup()
	if chkc then return chkc:IsOnField() and c88990328.filter(chkc,cg) end
	if chk==0 then return Duel.IsExistingTarget(c88990328.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c88990328.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c88990328.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
