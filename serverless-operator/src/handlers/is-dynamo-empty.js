import Debug from 'debug'
import {
  getAllDnsNameKeyPrefix
} from "../operations/state-management"

const debug = Debug('op:is-dynamo-empty')

export const handler = async (event, context) => {
  const loadbalancersDns = await getAllDnsNameKeyPrefix()
  debug('loadbalancersDns', loadbalancersDns)

  if (loadbalancersDns === null || loadbalancersDns.length === 0) {
    return {
      statusCode: 200,
      body: JSON.stringify('ok'),
    }
  }

  return {
    statusCode: 400,
    body: JSON.stringify(loadbalancersDns),
  }
}
