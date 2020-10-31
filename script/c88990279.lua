--点火骑士·铠甲
function c88990279.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),3,3,c88990279.lcheck)
	c:EnableReviveLimit()
	--immue
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c88990279.immcon)
	e1:SetValue(c88990279.efilter)
	e1:SetOwnerPlayer(tp)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetTarget(c88990279.destg)
	e2:SetOperation(c88990279.desop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c88990279.damcon)
	e3:SetTarget(c88990279.damtg)
	e3:SetOperation(c88990279.damop)
	c:RegisterEffect(e3)
	if not c88990279.global_check then
		c88990279.global_check=true
		c88990279[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c88990279.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c88990279.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c88990279.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc8)
end
function c88990279.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc8)
end
function c88990279.immcon(e)
	return Duel.IsExistingMatchingCard(c88990279.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c88990279.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c88990279.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c88990279.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c88990279.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c88990279.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c88990279.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xc8) then c88990279[0]=c88990279[0]+1 end
		tc=eg:GetNext()
	end
end
function c88990279.clearop(e,tp,eg,ep,ev,re,r,rp)
	c88990279[0]=0
end
function c88990279.damcon(e,tp,eg,ep,ev,re,r,rp)
	return c88990279[0]>0
end
function c88990279.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100*c88990279[0])
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100*c88990279[0])
end
function c88990279.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
