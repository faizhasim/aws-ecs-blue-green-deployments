import Debug from 'debug'
import {
  getAllDnsNameKeyPrefix,
  getDnsNamesWeight, getLoadBalancerZoneId,
  updateDnsNamesWeight} from "../operations/state-management"
import { Route53DomainName, Route53HostedZoneId } from '../operations/config'
import {upsertRoute53Records} from "../operations/route-53"

const debug = Debug('op:get-docker-tag-assignments')

const getAllWeight = async (dns0, dns1) => ({
  [dns0]: await getDnsNamesWeight(dns0),
  [dns1]: await getDnsNamesWeight(dns1)
})

export const handler = async (event, context) => {
  const loadbalancersDns = await getAllDnsNameKeyPrefix()
  debug('loadbalancersDns', loadbalancersDns)
  const [dns0, dns1] = loadbalancersDns

  const currentWeights = await getAllWeight(dns0, dns1)

  await updateDnsNamesWeight(dns0)(currentWeights[dns1])
  await updateDnsNamesWeight(dns1)(currentWeights[dns0])

  await upsertRoute53Records(
    Route53HostedZoneId,
    Route53DomainName,
    {
      aliasDnsName: dns0,
      aliasZoneId: await getLoadBalancerZoneId(dns0),
      weight: currentWeights[dns1]
    },
    {
      aliasDnsName: dns1,
      aliasZoneId: await getLoadBalancerZoneId(dns1),
      weight: currentWeights[dns0]
    }
  )

  return {
    statusCode: 200,
    body: 'ok',
  };
}


// handler()
